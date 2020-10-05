Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADC7283A2A
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgJEPbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgJEPbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51CA920663;
        Mon,  5 Oct 2020 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911894;
        bh=iLb0oMOz7yrGnKhpWZnHRUkZBIkrQEmtt98S69IRbMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLVuX4tGSdR0m0HHSYJGWYa4NDb3s3jRbUMY7SRn48VyghBFA7amgLjb0eFyQ9asR
         U8xKx9Aps3MOnO0HsT67E4eHQ/1r+4NSiuxMHc/s0Zn9GsH4fYA+BZWWvNlGdhhGds
         ZjQVggju3zMkKaYrU9A1hd/9K89eQi8KNAfiwtmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.8 21/85] memstick: Skip allocating card when removing host
Date:   Mon,  5 Oct 2020 17:26:17 +0200
Message-Id: <20201005142115.746441349@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 62c59a8786e6bb75569cee91dab66e9da3ff4b68 upstream.

After commit 6827ca573c03 ("memstick: rtsx_usb_ms: Support runtime power
management"), removing module rtsx_usb_ms will be stuck.

The deadlock is caused by powering on and powering off at the same time,
the former one is when memstick_check() is flushed, and the later is called
by memstick_remove_host().

Soe let's skip allocating card to prevent this issue.

Fixes: 6827ca573c03 ("memstick: rtsx_usb_ms: Support runtime power management")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200925084952.13220-1-kai.heng.feng@canonical.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memstick/core/memstick.c |    4 ++++
 include/linux/memstick.h         |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -441,6 +441,9 @@ static void memstick_check(struct work_s
 	} else if (host->card->stop)
 		host->card->stop(host->card);
 
+	if (host->removing)
+		goto out_power_off;
+
 	card = memstick_alloc_card(host);
 
 	if (!card) {
@@ -545,6 +548,7 @@ EXPORT_SYMBOL(memstick_add_host);
  */
 void memstick_remove_host(struct memstick_host *host)
 {
+	host->removing = 1;
 	flush_workqueue(workqueue);
 	mutex_lock(&host->lock);
 	if (host->card)
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -281,6 +281,7 @@ struct memstick_host {
 
 	struct memstick_dev *card;
 	unsigned int        retries;
+	bool removing;
 
 	/* Notify the host that some requests are pending. */
 	void                (*request)(struct memstick_host *host);


