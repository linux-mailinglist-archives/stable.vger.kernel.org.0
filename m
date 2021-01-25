Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF43304A9E
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbhAZFBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbhAYSvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A85420719;
        Mon, 25 Jan 2021 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600657;
        bh=l/zGaFYtxOBN/5QiDReeOLmWr4xJbplbVjj5J0cnOGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWSQ1oe08jEU2NCE2S//0h4OmKskaAm1QNKXDKWrwDpP/8MKGhumAPHRknid6kcss
         oPZk+RbDi1jHy7FBciNPPhnKcs9Nz1RxunrrIJRrdP0lOFVo3QfkRLg5cKr3QFIyHz
         N47CPPyR+7nlMASc8TaUAPu5uIDdYg5pA8R8yZWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elia Devito <eliadevito@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/199] platform/x86: hp-wmi: Dont log a warning on HPWMI_RET_UNKNOWN_COMMAND errors
Date:   Mon, 25 Jan 2021 19:38:43 +0100
Message-Id: <20210125183220.539373401@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d35c9a029a73e84d84337403d20b060494890570 ]

The recently added thermal policy support makes a
hp_wmi_perform_query(0x4c, ...) call on older devices which do not
support thermal policies this causes the following warning to be
logged (seen on a HP Stream x360 Convertible PC 11):

[   26.805305] hp_wmi: query 0x4c returned error 0x3

Error 0x3 is HPWMI_RET_UNKNOWN_COMMAND error. This commit silences
the warning for unknown-command errors, silencing the new warning.

Cc: Elia Devito <eliadevito@gmail.com>
Fixes: 81c93798ef3e ("platform/x86: hp-wmi: add support for thermal policy")
Link: https://lore.kernel.org/r/20210114232744.154886-1-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index ecd477964d117..18bf8aeb5f870 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -247,7 +247,8 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 	ret = bios_return->return_code;
 
 	if (ret) {
-		if (ret != HPWMI_RET_UNKNOWN_CMDTYPE)
+		if (ret != HPWMI_RET_UNKNOWN_COMMAND &&
+		    ret != HPWMI_RET_UNKNOWN_CMDTYPE)
 			pr_warn("query 0x%x returned error 0x%x\n", query, ret);
 		goto out_free;
 	}
-- 
2.27.0



