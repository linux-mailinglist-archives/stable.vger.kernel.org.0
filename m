Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264581EAC48
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731372AbgFASSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731902AbgFASSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:18:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC5B206E2;
        Mon,  1 Jun 2020 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035487;
        bh=MWL1sEHK2jPMKUmfRd6hIeDXg5zzx+400shcTXcX7Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2oiuvLA4TShEEodApBMFVkl53PpYAaO4lo9iKXDffC0diiTjElIr71D5ZlFe0etQ
         eYW0dIBda2ClKN+c815RVXEKfbA5R1jUqzAbxJNuzNg1irtrSzJevGURr+NJysp5OG
         NK1rF/COY/M7EneN6Jjywn6mYbWcnldh8a13UNxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.6 174/177] Revert "Input: i8042 - add ThinkPad S230u to i8042 nomux list"
Date:   Mon,  1 Jun 2020 19:55:12 +0200
Message-Id: <20200601174102.533641080@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f4dec2d6160976b14e54be9c3950ce0f52385741 upstream.

This reverts commit 18931506465a762ffd3f4803d36a18d336a67da9. From Kevin
Locke:

"... nomux only appeared to fix the issue because the controller
continued working after warm reboots. After more thorough testing from
both warm and cold start, I now believe the entry should be added to
i8042_dmi_reset_table rather than i8042_dmi_nomux_table as i8042.reset=1
alone is sufficient to avoid the issue from both states while
i8042.nomux is not."

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -541,13 +541,6 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
 		},
 	},
-	{
-		/* Lenovo ThinkPad Twist S230u */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "33474HU"),
-		},
-	},
 	{ }
 };
 


