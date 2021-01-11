Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D552F16B6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbhAKNHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbhAKNHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:07:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEDE2229C4;
        Mon, 11 Jan 2021 13:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370381;
        bh=GdJLnDoTFkY5cZjpLbI/rN99evKtxnOz1Dmc2CVeQF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gx0Y8tV9+25EvcW+v24qYf65SYNSEfMg2GeNmimS7YDL0cXcmBsVB3uP2sj67SgQl
         65059Kf7TH+Kg9ekeXQkMjCrcmnZX7gDymUY/2xr46MCmUQw44nfAmFE8+vIzF4GhH
         w6MKS8sVwGpoFIO2YTx8yQJXYdSA30U2c40/xo24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 53/57] Revert "device property: Keep secondary firmware node secondary by type"
Date:   Mon, 11 Jan 2021 14:02:12 +0100
Message-Id: <20210111130036.291420996@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
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
@@ -3090,7 +3090,7 @@ void set_primary_fwnode(struct device *d
 		if (fwnode_is_primary(fn)) {
 			dev->fwnode = fn->secondary;
 			if (!(parent && fn == parent->fwnode))
-				fn->secondary = ERR_PTR(-ENODEV);
+				fn->secondary = NULL;
 		} else {
 			dev->fwnode = NULL;
 		}


