Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2F9431D1A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhJRNsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233802AbhJRNpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:45:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBD1A615A7;
        Mon, 18 Oct 2021 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564149;
        bh=UKDdUxN31Y2tH8koy/hpWWmQl4c59XphxhJdnBYZU/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cW+jqD0kv9YG78cuViZYpjEiJdJg4DeH1NWt6LrIaRaNzf9NWbatELFXVZWSdk6Ff
         IyC32ovY2X5+lPqsYOVpJcxohqIthTPXtAh7CiZgnDhaEVibnAf1EdjU0lMPYmMrzg
         9F/0cn+bbgIZnhdPAiSAXD6o4mDPkUOjA3h00dFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 5.10 050/103] driver core: Reject pointless SYNC_STATE_ONLY device links
Date:   Mon, 18 Oct 2021 15:24:26 +0200
Message-Id: <20211018132336.434618524@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit f729a592adb6760013c3e48622a5bf256b992452 upstream.

SYNC_STATE_ONLY device links intentionally allow cycles because cyclic
sync_state() dependencies are valid and necessary.

However a SYNC_STATE_ONLY device link where the consumer and the supplier
are the same device is pointless because the device link would be deleted
as soon as the device probes (because it's also the consumer) and won't
affect when the sync_state() callback is called. It's a waste of CPU cycles
and memory to create this device link. So reject any attempts to create
such a device link.

Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
Cc: stable <stable@vger.kernel.org>
Reported-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210929190549.860541-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -549,7 +549,8 @@ struct device_link *device_link_add(stru
 {
 	struct device_link *link;
 
-	if (!consumer || !supplier || flags & ~DL_ADD_VALID_FLAGS ||
+	if (!consumer || !supplier || consumer == supplier ||
+	    flags & ~DL_ADD_VALID_FLAGS ||
 	    (flags & DL_FLAG_STATELESS && flags & DL_MANAGED_LINK_FLAGS) ||
 	    (flags & DL_FLAG_SYNC_STATE_ONLY &&
 	     flags != DL_FLAG_SYNC_STATE_ONLY) ||


