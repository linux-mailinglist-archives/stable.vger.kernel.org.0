Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28923643CA
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbhDSNVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240919AbhDSNTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F17613E7;
        Mon, 19 Apr 2021 13:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838113;
        bh=0DKbLwpRtrE8G4XtVlLlfF7mDlBZ8+CTdiglRTavET0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mL1Sewb4Muz6hwkrMBVvonvlDSmm+xE6gKC86XLsN9oWuNfnqMzVz/x3CwVUQ+4Hs
         r1TeiqrxQ+I6GMOjDECOJwWNdIOUiTb2Q6r5Af3Y9PFt2sksCEaw9Mx2csMorEi5k7
         kmodviY14WOfQ5GOdiGq8/Gs8QubN1nxHucaWrtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 048/103] Input: i8042 - fix Pegatron C15B ID entry
Date:   Mon, 19 Apr 2021 15:05:59 +0200
Message-Id: <20210419130529.470187442@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit daa58c8eec0a65ac8e2e77ff3ea8a233d8eec954 upstream.

The Zenbook Flip entry that was added overwrites a previous one
because of a typo:

In file included from drivers/input/serio/i8042.h:23,
                 from drivers/input/serio/i8042.c:131:
drivers/input/serio/i8042-x86ia64io.h:591:28: error: initialized field overwritten [-Werror=override-init]
  591 |                 .matches = {
      |                            ^
drivers/input/serio/i8042-x86ia64io.h:591:28: note: (near initialization for 'i8042_dmi_noselftest_table[0].matches')

Add the missing separator between the two.

Fixes: b5d6e7ab7fe7 ("Input: i8042 - add ASUS Zenbook Flip to noselftest list")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Link: https://lore.kernel.org/r/20210323130623.2302402-1-arnd@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-x86ia64io.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -588,6 +588,7 @@ static const struct dmi_system_id i8042_
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
 		},
+	}, {
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */


