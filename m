Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149893136A5
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhBHPNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhBHPKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C21764EB7;
        Mon,  8 Feb 2021 15:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796860;
        bh=C4b5iOsioRpDVUL7Jd1Ik8Jm38ik5r0hxDLRIlYUmxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQPQYSRRuMSPlIlKcGBoxa6KtwsDFi/Qy0Vws3lgTI4sysF2lhCqIAo8QLnt4aNCe
         O0Vmp3BU5W/N8tOwpmIdY3qfs2CuU+hD7zgEY7YXu0pAK2b+u5r3BfS8ZhPPk1XeHU
         KIRcKqzE7j/XMolI8cipar8nn+NHSTCNVuLol33M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gary Bisson <gary.bisson@boundarydevices.com>
Subject: [PATCH 4.19 15/38] usb: dwc3: fix clock issue during resume in OTG mode
Date:   Mon,  8 Feb 2021 16:01:02 +0100
Message-Id: <20210208145806.737879729@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary Bisson <gary.bisson@boundarydevices.com>

commit 0e5a3c8284a30f4c43fd81d7285528ece74563b5 upstream.

Commit fe8abf332b8f ("usb: dwc3: support clocks and resets for DWC3
core") introduced clock support and a new function named
dwc3_core_init_for_resume() which enables the clock before calling
dwc3_core_init() during resume as clocks get disabled during suspend.

Unfortunately in this commit the DWC3_GCTL_PRTCAP_OTG case was forgotten
and therefore during resume, a platform could call dwc3_core_init()
without re-enabling the clocks first, preventing to resume properly.

So update the resume path to call dwc3_core_init_for_resume() as it
should.

Fixes: fe8abf332b8f ("usb: dwc3: support clocks and resets for DWC3 core")
Cc: stable@vger.kernel.org
Signed-off-by: Gary Bisson <gary.bisson@boundarydevices.com>
Link: https://lore.kernel.org/r/20210125161934.527820-1-gary.bisson@boundarydevices.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1700,7 +1700,7 @@ static int dwc3_resume_common(struct dwc
 		if (PMSG_IS_AUTO(msg))
 			break;
 
-		ret = dwc3_core_init(dwc);
+		ret = dwc3_core_init_for_resume(dwc);
 		if (ret)
 			return ret;
 


