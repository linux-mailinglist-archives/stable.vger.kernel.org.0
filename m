Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CD03E3403
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 10:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhHGIEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 04:04:41 -0400
Received: from sender4-of-o58.zoho.com ([136.143.188.58]:21820 "EHLO
        sender4-of-o58.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhHGIEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 04:04:40 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Aug 2021 04:04:40 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1628322557; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=l40szTu1hqq5GSEnEnPDR39vXkkYCRGMdLk8xp5+JtHQ3+Yy3/zsp88gQqSxs/2hOSbE/wXDz2+6+PYU4jZ86NLHdTuBXAd00FGvVZnBbBfk3a7hKcMwGmOM0ZuNmukpbDxwjUIG+oqyw89MveRKU2DL0dRudaAd58lQKVEExrU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1628322557; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=pnf0asVTLQ8twpx7JhDk1Ucgi+h2fh0K9avlTzvWVHQ=; 
        b=bOU56hRDrmG/5ILkcYZ0GQwxYs499aUzabgYqrvzZpzoHnxXI/TG039U3zPolXSxYiZ2nXWojBlzpBqX+2u1MWIZWkA2rJVCmHJYekvbVoWLNUziDIGQ4osET6kS2eJ/vZbPvzFOmVg4p2w2P50//cfHtIopIWrHQ4F/PxsRxrQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=fnordco.com;
        spf=pass  smtp.mailfrom=klaatu@fnordco.com;
        dmarc=pass header.from=<jwoods@fnordco.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1628322557;
        s=zoho; d=fnordco.com; i=jwoods@fnordco.com;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=pnf0asVTLQ8twpx7JhDk1Ucgi+h2fh0K9avlTzvWVHQ=;
        b=LDo56lQpVhdsAn/33CwTeIHWKT3q0BdKuOXNFh7R3ah7F2yjAYBVchwXn9xVW+61
        N1HJdiTX69aVVS1e3f119905TpTmlxibh3SNpuwUJW+Sv5g8LClAe1n7+zn4Xlh2r7S
        Q55dGoxnn9GXsMHKljfHnsBS4GuAoo+7p6AHM5c8=
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1628322547718417.0875227115416; Sat, 7 Aug 2021 00:49:07 -0700 (PDT)
Date:   Sat, 07 Aug 2021 00:49:07 -0700
From:   Jeff Woods <jwoods@fnordco.com>
To:     "stable" <stable@vger.kernel.org>
Cc:     "regressions" <regressions@lists.linux.dev>
Message-ID: <17b1f9647ee.1179b6a05461889.5940365952430364689@fnordco.com>
In-Reply-To: 
Subject: Kernel 5.13.6 breaks mmap with snd-hdsp module
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Specifically, commit c4824ae7db418aee6f50f308a20b832e58e997fd triggers the problem. Reverting this change restores functionality.

The device is an RME Multiface II, using the snd-hdsp driver.

Expected behavior: Device plays sound normally

Exhibited behavior: When a program attempts to open the device, the following ALSA lib error happens:

ALSA lib pcm_direct.c:1169:(snd1_pcm_direct_initialize_slave) slave plugin does not support mmap interleaved or mmap noninterleaved access

This change hasn't affected my other computers with less esoteric hardware, so probably the problem lies with the snd-hdsp driver, but the device is unusable without reverting that commit.

I am available to test any patches for this issue.

Thanks,
J Woods
