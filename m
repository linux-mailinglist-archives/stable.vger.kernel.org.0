Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6443137E9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhBHPdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhBHP3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:29:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E7EE64F2E;
        Mon,  8 Feb 2021 15:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797399;
        bh=ilixUZofVXuX/kSws9C+KNaGMev1IFswAxbrRQ9+eEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjwEFUon2oxmnaInhf+SMOa0m42KJccS1BvHtdydXwrokyQXsZA23xEn7BDsBRcy4
         6EkkIR2r1Z3+2JvKlXobn8c9asv/5u1c/VYFKq31D++t2yfB4L5FJiOx4vuqrRZD8T
         fpCeSoJd0kntABev4hC9bCQjjFiBvXG7MCbKQKp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 064/120] libnvdimm/namespace: Fix visibility of namespace resource attribute
Date:   Mon,  8 Feb 2021 16:00:51 +0100
Message-Id: <20210208145820.980486149@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 13f445d65955f388499f00851dc9a86280970f7c upstream.

Legacy pmem namespaces lost support for the "resource" attribute when
the code was cleaned up to put the permission visibility in the
declaration. Restore this by listing 'resource' in the default
attributes.

A new ndctl regression test for pfn_to_online_page() corner cases builds
on this fix.

Fixes: bfd2e9140656 ("libnvdimm: Simplify root read-only definition for the 'resource' attribute")
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/161052334995.1805594.12054873528154362921.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/namespace_devs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1635,11 +1635,11 @@ static umode_t namespace_visible(struct
 		return a->mode;
 	}
 
-	if (a == &dev_attr_nstype.attr || a == &dev_attr_size.attr
-			|| a == &dev_attr_holder.attr
-			|| a == &dev_attr_holder_class.attr
-			|| a == &dev_attr_force_raw.attr
-			|| a == &dev_attr_mode.attr)
+	/* base is_namespace_io() attributes */
+	if (a == &dev_attr_nstype.attr || a == &dev_attr_size.attr ||
+	    a == &dev_attr_holder.attr || a == &dev_attr_holder_class.attr ||
+	    a == &dev_attr_force_raw.attr || a == &dev_attr_mode.attr ||
+	    a == &dev_attr_resource.attr)
 		return a->mode;
 
 	return 0;


