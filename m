Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322191FB883
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733091AbgFPPzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733085AbgFPPzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:55:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89299207C4;
        Tue, 16 Jun 2020 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322935;
        bh=FFSxGwBGfMCiFQduasCBES4XmyOFzA/eJW0MOePvNZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXuw0ArzZtGVjpgat6pkWKzJoWO3bHbaIQjKnOXducIVV51QMHNisRxU9tl9ezVK0
         AyOtrYztgrT9znONp4MvTsV/7F572lc3T9P00A2h0RZ/9gGq8B6gqiB5oQVTdVQQDt
         SoBHsBtQgarxvk1MznOluPZFL4sKavuzL89sYaYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Mierzejewski <dominik@greysector.net>,
        Mattia Dongili <malattia@linux.it>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.6 159/161] platform/x86: sony-laptop: Make resuming thermal profile safer
Date:   Tue, 16 Jun 2020 17:35:49 +0200
Message-Id: <20200616153113.952867377@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattia Dongili <malattia@linux.it>

commit 476d60b1b4c8a2b14a53ef9b772058f35e604661 upstream.

The thermal handle object may fail initialization when the module is
loaded in the first place. Avoid attempting to use it on resume then.

Fixes: 6d232b29cfce ("ACPICA: Dispatcher: always generate buffer objects for ASL create_field() operator")
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207491
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/sony-laptop.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -2288,7 +2288,12 @@ static void sony_nc_thermal_cleanup(stru
 #ifdef CONFIG_PM_SLEEP
 static void sony_nc_thermal_resume(void)
 {
-	unsigned int status = sony_nc_thermal_mode_get();
+	int status;
+
+	if (!th_handle)
+		return;
+
+	status = sony_nc_thermal_mode_get();
 
 	if (status != th_handle->mode)
 		sony_nc_thermal_mode_set(th_handle->mode);


