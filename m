Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6477303301
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbhAZEo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbhAYSmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B19423105;
        Mon, 25 Jan 2021 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600129;
        bh=QuJmZNIir1CDuoiX+eW7XOgiW57FkfJXOpL5Q1c2yYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GE7Sm+/VWhxAxwPvVcbwqwWGZSQw4Vujnv6/lXSOmN02JCGhgoVDnHEH8XWMY6nLQ
         GlyRD/oQsAQdzpXPJ/eO9sbKVGY0EOEq2YSIQfu73zdFo+mlrrZ6CLYuRjKNqHCczR
         AjWURGhQ/6UzRaM3ZaFAI6pSDzp13pIljyPryW38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 43/58] driver core: Extend device_is_dependent()
Date:   Mon, 25 Jan 2021 19:39:44 +0100
Message-Id: <20210125183158.568871999@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 3d1cf435e201d1fd63e4346b141881aed086effd upstream.

If the device passed as the target (second argument) to
device_is_dependent() is not completely registered (that is, it has
been initialized, but not added yet), but the parent pointer of it
is set, it may be missing from the list of the parent's children
and device_for_each_child() called by device_is_dependent() cannot
be relied on to catch that dependency.

For this reason, modify device_is_dependent() to check the ancestors
of the target device by following its parent pointer in addition to
the device_for_each_child() walk.

Fixes: 9ed9895370ae ("driver core: Functional dependencies tracking support")
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/17705994.d592GUb2YH@kreacher
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -93,6 +93,16 @@ void device_links_read_unlock(int not_us
 }
 #endif /* !CONFIG_SRCU */
 
+static bool device_is_ancestor(struct device *dev, struct device *target)
+{
+	while (target->parent) {
+		target = target->parent;
+		if (dev == target)
+			return true;
+	}
+	return false;
+}
+
 /**
  * device_is_dependent - Check if one device depends on another one
  * @dev: Device to check dependencies for.
@@ -106,7 +116,12 @@ static int device_is_dependent(struct de
 	struct device_link *link;
 	int ret;
 
-	if (dev == target)
+	/*
+	 * The "ancestors" check is needed to catch the case when the target
+	 * device has not been completely initialized yet and it is still
+	 * missing from the list of children of its parent device.
+	 */
+	if (dev == target || device_is_ancestor(dev, target))
 		return 1;
 
 	ret = device_for_each_child(dev, target, device_is_dependent);


