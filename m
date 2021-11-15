Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1E2450E70
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhKOSPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240313AbhKOSHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 323D663306;
        Mon, 15 Nov 2021 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998272;
        bh=OXRQUmIw8c6w3x5521GPDy04TPzDpS7Q4dc2midSmIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+Ixx6CD6F0eAKXqW2DAf/Ii0gT089zgKrho98px+n6CYR2dh/+bmSHGkmrvNkVXV
         Wlcy9wqLnS5rPLO/J/PidODbrv0ESY+mbgkt9iPXuqTiy36A//uxqhmmrVAeWuv9wm
         J5/h4qeaRIFPgYYNGWktwyj6xz7SfHDYLvF3cavU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Guru Das Srinagesh <quic_gurus@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/575] firmware: qcom_scm: Fix error retval in __qcom_scm_is_call_available()
Date:   Mon, 15 Nov 2021 18:02:55 +0100
Message-Id: <20211115165359.316721679@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guru Das Srinagesh <quic_gurus@quicinc.com>

[ Upstream commit 38212b2a8a6fc4c3a6fa99d7445b833bedc9a67c ]

Since __qcom_scm_is_call_available() returns bool, have it return false
instead of -EINVAL if an invalid SMC convention is detected.

This fixes the Smatch static checker warning:

	drivers/firmware/qcom_scm.c:255 __qcom_scm_is_call_available()
	warn: signedness bug returning '(-22)'

Fixes: 9d11af8b06a8 ("firmware: qcom_scm: Make __qcom_scm_is_call_available() return bool")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Guru Das Srinagesh <quic_gurus@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1633982414-28347-1-git-send-email-quic_gurus@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index c5b20bdc08e9d..e10a99860ca4b 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -252,7 +252,7 @@ static bool __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
 		break;
 	default:
 		pr_err("Unknown SMC convention being used\n");
-		return -EINVAL;
+		return false;
 	}
 
 	ret = qcom_scm_call(dev, &desc, &res);
-- 
2.33.0



