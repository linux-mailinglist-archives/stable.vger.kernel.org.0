Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F1D16325B
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgBRT6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgBRT6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:58:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05D920659;
        Tue, 18 Feb 2020 19:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055882;
        bh=tiQFygU+6caMUo6KTU6OL9ZWBmUqQI7c5sgTqloa6go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQyz768ZirPniDhX4iG7UwUiPnZshwzGo1lXtMv8NbPKxf+FJYaTXIZBhzJOlD4/F
         ZNGwT8ePV6VHTakK4eTrzUbZe561Zi6LVWaDOjKhSu7YZHkx4/Gk1buH/4gPRtPah4
         2fqZ2DnCYgmNXr72MWccFlaLUWB9o+JdjYZ9g3G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 11/66] ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system
Date:   Tue, 18 Feb 2020 20:54:38 +0100
Message-Id: <20200218190429.147740614@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit fdde0ff8590b4c1c41b3227f5ac4265fccccb96b upstream.

If the platform triggers a spurious SCI even though the status bit
is not set for any GPE when the system is suspended to idle, it will
be treated as a genuine wakeup, so avoid that by checking if any GPEs
are active at all before returning 'true' from acpi_s2idle_wake().

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206413
Fixes: 56b991849009 ("PM: sleep: Simplify suspend-to-idle control flow")
Reported-by: Tsuchiya Yuto <kitakar@gmail.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -993,10 +993,16 @@ static bool acpi_s2idle_wake(void)
 			return true;
 
 		/*
-		 * If there are no EC events to process, the wakeup is regarded
-		 * as a genuine one.
+		 * If there are no EC events to process and at least one of the
+		 * other enabled GPEs is active, the wakeup is regarded as a
+		 * genuine one.
+		 *
+		 * Note that the checks below must be carried out in this order
+		 * to avoid returning prematurely due to a change of the EC GPE
+		 * status bit from unset to set between the checks with the
+		 * status bits of all the other GPEs unset.
 		 */
-		if (!acpi_ec_dispatch_gpe())
+		if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
 			return true;
 
 		/*


