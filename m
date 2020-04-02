Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E58719C7C3
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388815AbgDBRRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:17:48 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44309 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388970AbgDBRRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 13:17:48 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=localhost)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1jK3TK-00033z-JL; Thu, 02 Apr 2020 19:17:42 +0200
Message-ID: <bed38c9d9d5ba71d26fce8a17cfbbe9c0e807300.camel@pengutronix.de>
Subject: Re: [PATCH v4.19.y, v4.14.y, v4.9.y] drm/etnaviv: Backport fix for
 mmu flushing
From:   Lucas Stach <l.stach@pengutronix.de>
To:     bob.beckett@collabora.com,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        David Airlie <airlied@linux.ie>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Thu, 02 Apr 2020 19:17:40 +0200
In-Reply-To: <20200402170758.8315-1-bob.beckett@collabora.com>
References: <20200402170758.8315-1-bob.beckett@collabora.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, den 02.04.2020, 18:07 +0100 schrieb Robert Beckett:
> commit 4900dda90af2cb13bc1d4c12ce94b98acc8fe64e upstream
> 
> Due to async need_flush updating via other buffer mapping, checking
> gpu->need_flush in 3 places within etnaviv_buffer_queue can cause GPU
> hangs.
> 
> This occurs due to need_flush being false for the first 2 checks in that
> function, so that the extra dword does not get accounted for, but by the
> time we come to check for the third time, gpu->mmu->need_flish is true,
> which outputs the flush instruction. This causes the prefetch during the
> final link to be off by 1. This causes GPU hangs.

Yep, there should have been a READ_ONCE on this state. :/

> It causes the ring to contain patterns like this:
> 
> 0x40000005, /* LINK (8) PREFETCH=0x5,OP=LINK */                                                      
> 0x70040010, /*   ADDRESS *0x70040010 */                                                              
> 0x40000002, /* LINK (8) PREFETCH=0x2,OP=LINK */                                                      
> 0x70040000, /*   ADDRESS *0x70040000 */                                                              
> 0x08010e04, /* LOAD_STATE (1) Base: 0x03810 Size: 1 Fixp: 0 */                                       
> 0x0000001f, /*   GL.FLUSH_MMU := FLUSH_FEMMU=1,FLUSH_UNK1=1,FLUSH_UNK2=1,FLUSH_PEMMU=1,FLUSH_UNK4=1 */
> 0x08010e03, /* LOAD_STATE (1) Base: 0x0380C Size: 1 Fixp: 0 */                                       
> 0x00000000, /*   GL.FLUSH_CACHE := DEPTH=0,COLOR=0,TEXTURE=0,PE2D=0,TEXTUREVS=0,SHADER_L1=0,SHADER_L2=0,UNK10=0,UNK11=0,DESCRIPTOR_UNK12=0,DESCRIPTOR_UNK13=0 */
> 0x08010e02, /* LOAD_STATE (1) Base: 0x03808 Size: 1 Fixp: 0 */                                       
> 0x00000701, /*   GL.SEMAPHORE_TOKEN := FROM=FE,TO=PE,UNK28=0x0 */                                    
> 0x48000000, /* STALL (9) OP=STALL */                                                                 
> 0x00000701, /*   TOKEN FROM=FE,TO=PE,UNK28=0x0 */                                                    
> 0x08010e00, /* LOAD_STATE (1) Base: 0x03800 Size: 1 Fixp: 0 */                                       
> 0x00000000, /*   GL.PIPE_SELECT := PIPE=PIPE_3D */                                                   
> 0x40000035, /* LINK (8) PREFETCH=0x35,OP=LINK */                                                     
> 0x70041000, /*   ADDRESS *0x70041000 */
> 
> Here we see a link with prefetch of 5 dwords starting with the 3rd
> instruction. It only loads the 5 dwords up and including the final
> LOAD_STATE. It needs to include the final LINK instruction.
> 
> This was seen on imx6q, and the fix is confirmed to stop the GPU hangs.
> 
> The commit referenced inadvertently fixed this issue by checking
> gpu->mmu->need_flush once at the start of the function.
> Given that this commit is independant, and useful for all version, it
> seems sensible to backport it to the stable branches.

I agree. Without shared MMUs this doesn't really need to be sequence,
but better just to backport this change, which has seen quite some
testing, than creating yet another, slightly different, version of this
function in the stable branches.

Regards,
Lucas

