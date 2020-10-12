Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216B628B9BC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389463AbgJLODM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731009AbgJLNhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59D3221FC;
        Mon, 12 Oct 2020 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509809;
        bh=2BdFwFQtTbQE3+U5mDfKpEwafb59mUIhSlTGuBmQSJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfgHvhJQJFz5+ZRrr6CS2BhJ38FO+/wOYzbgURl+C2PNg5n431RkeRr9tlMCSMGVh
         RYZMGy4MtGKHmYYUxkANHu7JnsGVdQWrzL6qCy8nxLkCbJf82FAPAN+dYXkUnhvykA
         NhZ+8NsVMy1k5cN+ubm6sSTy3XsjHIFO5oOcR1Cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        mark gross <mgross@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.14 38/70] platform/x86: thinkpad_acpi: initialize tp_nvram_state variable
Date:   Mon, 12 Oct 2020 15:26:54 +0200
Message-Id: <20201012132632.012673485@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 5f38b06db8af3ed6c2fc1b427504ca56fae2eacc upstream.

clang static analysis flags this represenative problem
thinkpad_acpi.c:2523:7: warning: Branch condition evaluates
  to a garbage value
                if (!oldn->mute ||
                    ^~~~~~~~~~~

In hotkey_kthread() mute is conditionally set by hotkey_read_nvram()
but unconditionally checked by hotkey_compare_and_issue_event().
So the tp_nvram_state variable s[2] needs to be initialized.

Fixes: 01e88f25985d ("ACPI: thinkpad-acpi: add CMOS NVRAM polling for hot keys (v9)")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: mark gross <mgross@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2477,7 +2477,7 @@ static void hotkey_compare_and_issue_eve
  */
 static int hotkey_kthread(void *data)
 {
-	struct tp_nvram_state s[2];
+	struct tp_nvram_state s[2] = { 0 };
 	u32 poll_mask, event_mask;
 	unsigned int si, so;
 	unsigned long t;


