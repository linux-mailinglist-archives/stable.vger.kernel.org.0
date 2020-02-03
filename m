Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C207D150B00
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgBCQUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728984AbgBCQUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:20:52 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B899A2082E;
        Mon,  3 Feb 2020 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580746852;
        bh=Ng+xPgKDS+kdlTzojj6DGNvUJu4znB1zBFNtz6PAXvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPw5b9309C5S5Os4mUa1QVDd6xqhLSn+2T1f18sJELPJ6kX2IQyoHHVjSZT8RkBrz
         Gq1n7dLSdZL0QaDJm+UBk/anWHf+qpQIW4/avSCwfv6tbCRYQhAx+qcwKXMk52GFBI
         DBCt6Ww35Cn0AK9GYeGZXyBMP7S71Ia5f4bYKOX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 32/53] usb: dwc3: turn off VBUS when leaving host mode
Date:   Mon,  3 Feb 2020 16:19:24 +0000
Message-Id: <20200203161908.866733370@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
References: <20200203161902.714326084@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Liu <b-liu@ti.com>

[ Upstream commit 09ed259fac621634d51cd986aa8d65f035662658 ]

VBUS should be turned off when leaving the host mode.
Set GCTL_PRTCAP to device mode in teardown to de-assert DRVVBUS pin to
turn off VBUS power.

Fixes: 5f94adfeed97 ("usb: dwc3: core: refactor mode initialization to its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 4378e758baef9..591bc3f7be763 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -801,6 +801,9 @@ static void dwc3_core_exit_mode(struct dwc3 *dwc)
 		/* do nothing */
 		break;
 	}
+
+	/* de-assert DRVVBUS for HOST and OTG mode */
+	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
 }
 
 #define DWC3_ALIGN_MASK		(16 - 1)
-- 
2.20.1



