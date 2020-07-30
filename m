Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADC4232DAD
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgG3IMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730063AbgG3IMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:12:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87BD52070B;
        Thu, 30 Jul 2020 08:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096755;
        bh=0TS8vaOu8U0C0bL3BfPsJsUIqCQxjQ5c4Kkh2xglFhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPuvJ5MKQpenadQFe5svGsQLk6WpRFMQ95424h9DxYXn/VJsRBxdCqRFm2Mpb19A3
         thFus3om5JFVxx7M+GGrd3FUmMTPDpmHuyDVu75EfF1985RqoUN+y210qzX7fjhCi5
         ZSEWWLj4waptExhnZoWKuc4xmroTLVabYN7bqXRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 48/54] regmap: debugfs: check count when read regmap file
Date:   Thu, 30 Jul 2020 10:05:27 +0200
Message-Id: <20200730074423.496275329@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit 74edd08a4fbf51d65fd8f4c7d8289cd0f392bd91 upstream.

When executing the following command, we met kernel dump.
dmesg -c > /dev/null; cd /sys;
for i in `ls /sys/kernel/debug/regmap/* -d`; do
	echo "Checking regmap in $i";
	cat $i/registers;
done && grep -ri "0x02d0" *;

It is because the count value is too big, and kmalloc fails. So add an
upper bound check to allow max size `PAGE_SIZE << (MAX_ORDER - 1)`.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/1584064687-12964-1-git-send-email-peng.fan@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap-debugfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -194,6 +194,9 @@ static ssize_t regmap_read_debugfs(struc
 	if (*ppos < 0 || !count)
 		return -EINVAL;
 
+	if (count > (PAGE_SIZE << (MAX_ORDER - 1)))
+		count = PAGE_SIZE << (MAX_ORDER - 1);
+
 	buf = kmalloc(count, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -342,6 +345,9 @@ static ssize_t regmap_reg_ranges_read_fi
 	if (*ppos < 0 || !count)
 		return -EINVAL;
 
+	if (count > (PAGE_SIZE << (MAX_ORDER - 1)))
+		count = PAGE_SIZE << (MAX_ORDER - 1);
+
 	buf = kmalloc(count, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;


