Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65738F00A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhEXQA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235727AbhEXP75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30C0561981;
        Mon, 24 May 2021 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871137;
        bh=iChOY2BbqP5Ne9jolqutQUA/h+RwCBh2ye+73UiWiG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOEDq0ROnSU78b73zFka9mh8VmQup1enjO+eBeqzfcPf07B9Yq+yDT1JNhDNaEl7F
         JmPivdEnqtwng5QrCt+GxOH24/Hd5O+uAkd2xCuvtJVqp+e1t5sJLLjnLc92WAdQdL
         3fbjXe9kcy68b5IQT6N0kvBBodqzsD8n68o3RFKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.12 063/127] platform/x86: ideapad-laptop: fix method name typo
Date:   Mon, 24 May 2021 17:26:20 +0200
Message-Id: <20210524152336.976819188@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barnabás Pőcze <pobrn@protonmail.com>

commit b09aaa3f2c0edeeed670cd29961a0e35bddc78cf upstream.

"smbc" should be "sbmc". `eval_smbc()` incorrectly called
the SMBC ACPI method instead of SBMC. This resulted in
partial loss of functionality. Rectify that by calling
the correct ACPI method (SBMC), and also rename
methods and constants.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212985
Fixes: 0b765671cb80 ("platform/x86: ideapad-laptop: group and separate (un)related constants into enums")
Fixes: ff36b0d953dc ("platform/x86: ideapad-laptop: rework and create new ACPI helpers")
Cc: stable@vger.kernel.org # 5.12
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Link: https://lore.kernel.org/r/20210507235333.286505-1-pobrn@protonmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -57,8 +57,8 @@ enum {
 };
 
 enum {
-	SMBC_CONSERVATION_ON  = 3,
-	SMBC_CONSERVATION_OFF = 5,
+	SBMC_CONSERVATION_ON  = 3,
+	SBMC_CONSERVATION_OFF = 5,
 };
 
 enum {
@@ -182,9 +182,9 @@ static int eval_gbmd(acpi_handle handle,
 	return eval_int(handle, "GBMD", res);
 }
 
-static int exec_smbc(acpi_handle handle, unsigned long arg)
+static int exec_sbmc(acpi_handle handle, unsigned long arg)
 {
-	return exec_simple_method(handle, "SMBC", arg);
+	return exec_simple_method(handle, "SBMC", arg);
 }
 
 static int eval_hals(acpi_handle handle, unsigned long *res)
@@ -477,7 +477,7 @@ static ssize_t conservation_mode_store(s
 	if (err)
 		return err;
 
-	err = exec_smbc(priv->adev->handle, state ? SMBC_CONSERVATION_ON : SMBC_CONSERVATION_OFF);
+	err = exec_sbmc(priv->adev->handle, state ? SBMC_CONSERVATION_ON : SBMC_CONSERVATION_OFF);
 	if (err)
 		return err;
 


