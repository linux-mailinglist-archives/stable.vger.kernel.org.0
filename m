Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8792F13B2
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbhAKNN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731818AbhAKNNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDDA9229C4;
        Mon, 11 Jan 2021 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370758;
        bh=9T8pFcfevffuEgPCrRo0iDbr091RgC2y2gqnJBt1GjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awHBeLZDmU5Q11vE7Qz/GF2PrGdv9p+aonSrihA6i8MbDDKAmctAQAcJRIxE9sAjl
         1Y5N6xHalOza0gsZ8XAUaECClUe4rMLT/d704DE7mP1BCAqODIx5xze6OfaR8rR9Ia
         LovbQ2WYDPwgaphHqtpsWpD1E/HJjGj0B+vC9LMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 84/92] Revert "device property: Keep secondary firmware node secondary by type"
Date:   Mon, 11 Jan 2021 14:02:28 +0100
Message-Id: <20210111130043.203741289@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit 47f4469970d8861bc06d2d4d45ac8200ff07c693 upstream.

While commit d5dcce0c414f ("device property: Keep secondary firmware
node secondary by type") describes everything correct in its commit
message, the change it made does the opposite and original commit
c15e1bdda436 ("device property: Fix the secondary firmware node handling
in set_primary_fwnode()") was fully correct.

Revert the former one here and improve documentation in the next patch.

Fixes: d5dcce0c414f ("device property: Keep secondary firmware node secondary by type")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3414,7 +3414,7 @@ void set_primary_fwnode(struct device *d
 		if (fwnode_is_primary(fn)) {
 			dev->fwnode = fn->secondary;
 			if (!(parent && fn == parent->fwnode))
-				fn->secondary = ERR_PTR(-ENODEV);
+				fn->secondary = NULL;
 		} else {
 			dev->fwnode = NULL;
 		}


