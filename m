Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAD919C7A3
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732404AbgDBRIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:08:25 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45112 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731608AbgDBRIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 13:08:24 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 5C6E3297E43
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        David Airlie <airlied@linux.ie>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v4.19.y, v4.14.y, v4.9.y] drm/etnaviv: Backport fix for mmu flushing
Date:   Thu,  2 Apr 2020 18:07:55 +0100
Message-Id: <20200402170758.8315-1-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.20.1
Reply-To: <bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4900dda90af2cb13bc1d4c12ce94b98acc8fe64e upstream

Due to async need_flush updating via other buffer mapping, checking
gpu->need_flush in 3 places within etnaviv_buffer_queue can cause GPU
hangs.

This occurs due to need_flush being false for the first 2 checks in that
function, so that the extra dword does not get accounted for, but by the
time we come to check for the third time, gpu->mmu->need_flish is true,
which outputs the flush instruction. This causes the prefetch during the
final link to be off by 1. This causes GPU hangs.

It causes the ring to contain patterns like this:

0x40000005, /* LINK (8) PREFETCH=0x5,OP=LINK */                                                      
0x70040010, /*   ADDRESS *0x70040010 */                                                              
0x40000002, /* LINK (8) PREFETCH=0x2,OP=LINK */                                                      
0x70040000, /*   ADDRESS *0x70040000 */                                                              
0x08010e04, /* LOAD_STATE (1) Base: 0x03810 Size: 1 Fixp: 0 */                                       
0x0000001f, /*   GL.FLUSH_MMU := FLUSH_FEMMU=1,FLUSH_UNK1=1,FLUSH_UNK2=1,FLUSH_PEMMU=1,FLUSH_UNK4=1 */
0x08010e03, /* LOAD_STATE (1) Base: 0x0380C Size: 1 Fixp: 0 */                                       
0x00000000, /*   GL.FLUSH_CACHE := DEPTH=0,COLOR=0,TEXTURE=0,PE2D=0,TEXTUREVS=0,SHADER_L1=0,SHADER_L2=0,UNK10=0,UNK11=0,DESCRIPTOR_UNK12=0,DESCRIPTOR_UNK13=0 */
0x08010e02, /* LOAD_STATE (1) Base: 0x03808 Size: 1 Fixp: 0 */                                       
0x00000701, /*   GL.SEMAPHORE_TOKEN := FROM=FE,TO=PE,UNK28=0x0 */                                    
0x48000000, /* STALL (9) OP=STALL */                                                                 
0x00000701, /*   TOKEN FROM=FE,TO=PE,UNK28=0x0 */                                                    
0x08010e00, /* LOAD_STATE (1) Base: 0x03800 Size: 1 Fixp: 0 */                                       
0x00000000, /*   GL.PIPE_SELECT := PIPE=PIPE_3D */                                                   
0x40000035, /* LINK (8) PREFETCH=0x35,OP=LINK */                                                     
0x70041000, /*   ADDRESS *0x70041000 */

Here we see a link with prefetch of 5 dwords starting with the 3rd
instruction. It only loads the 5 dwords up and including the final
LOAD_STATE. It needs to include the final LINK instruction.

This was seen on imx6q, and the fix is confirmed to stop the GPU hangs.

The commit referenced inadvertently fixed this issue by checking
gpu->mmu->need_flush once at the start of the function.
Given that this commit is independant, and useful for all version, it
seems sensible to backport it to the stable branches.


