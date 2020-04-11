Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA4F1A51AC
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgDKMOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbgDKMOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F81B20692;
        Sat, 11 Apr 2020 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607276;
        bh=o+4mYtswxyny3XsI8zlDx+U3Pz3LrrKAh0UyVtGB1Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWBWHXetOLXuNvp6IhY01ZVwerBJbIvHIVwHntck3RCOyXfauUXdKCGPMMaMujiEo
         gq38lEsX2f+9tdsBVX0tBAjH8yVkm4bgA5Z5f+LJNIa4A3cs7dQzcr3Iyk0JzpIAze
         NFvIJwwkCNAzJ9AhBws/u5YIahbidiV1B1giBKNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lew <clew@codeaurora.org>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 36/38] rpmsg: glink: Remove chunk size word align warning
Date:   Sat, 11 Apr 2020 14:09:20 +0200
Message-Id: <20200411115441.303886448@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

commit f0beb4ba9b185d497c8efe7b349363700092aee0 upstream.

It is possible for the chunk sizes coming from the non RPM remote procs
to not be word aligned. Remove the alignment warning and continue to
read from the FIFO so execution is not stalled.

Signed-off-by: Chris Lew <clew@codeaurora.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/qcom_glink_native.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -811,9 +811,6 @@ static int qcom_glink_rx_data(struct qco
 		return -EAGAIN;
 	}
 
-	if (WARN(chunk_size % 4, "Incoming data must be word aligned\n"))
-		return -EINVAL;
-
 	rcid = le16_to_cpu(hdr.msg.param1);
 	spin_lock_irqsave(&glink->idr_lock, flags);
 	channel = idr_find(&glink->rcids, rcid);


