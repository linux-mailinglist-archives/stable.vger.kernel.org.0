Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4212443ED
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 05:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHND0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 23:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgHND0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 23:26:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 849E320715;
        Fri, 14 Aug 2020 03:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597375576;
        bh=/yiPDvtR1a9jtr2CiK2Zgh5RLxl6HDHqUsur1T1w+CQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Gjo/M/uB8RiCjQxuqnHCJ0rZ3tfXWMCPjNK29VQwW3q2nkMsYw7W17ugaMeVYNUWt
         v2UdNyk0dgU7LWfZ1o+aE2G/Mjf/cCRWLSl4qhNLktzGTGBpPrUMVspJzvlSGGSd6Y
         pLjsWhEkw83/ALhn87dfzQ0AB/tGH/iDvX8/B8+8=
Date:   Thu, 13 Aug 2020 20:26:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mhiramat@kernel.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, stable@vger.kernel.org
Subject:  [withdrawn]
 bootconfig-fix-off-by-one-in-xbc_node_compose_key_after.patch removed from
 -mm tree
Message-ID: <20200814032616.RsvJTx4qb%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: bootconfig: fix off-by-one in xbc_node_compose_key_after()
has been removed from the -mm tree.  Its filename was
     bootconfig-fix-off-by-one-in-xbc_node_compose_key_after.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Steven Rostedt (VMware) <rostedt@goodmis.org>
Subject: bootconfig: fix off-by-one in xbc_node_compose_key_after()

While reviewing some patches for bootconfig, I noticed the following
code in xbc_node_compose_key_after():

	ret = snprintf(buf, size, "%s%s", xbc_node_get_data(node),
		       depth ? "." : "");
	if (ret < 0)
		return ret;
	if (ret > size) {
		size = 0;
	} else {
		size -= ret;
		buf += ret;
	}

But snprintf() returns the number of bytes that would be written, not
the number of bytes that are written (ignoring the nul terminator).
This means that if the number of non null bytes written were to equal
size, then the nul byte, which snprintf() always adds, will overwrite
that last byte.

	ret = snprintf(buf, 5, "hello");
	printf("buf = '%s'
", buf);
	printf("ret = %d
", ret);

produces:

	buf = 'hell'
	ret = 5

The string was truncated without ret being greater than 5.
Test (ret >= size) for overwrite.

Link: http://lkml.kernel.org/r/20200813183050.029a6003@oasis.local.home
Fixes: 76db5a27a827c ("bootconfig: Add Extra Boot Config support")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-fix-off-by-one-in-xbc_node_compose_key_after
+++ a/lib/bootconfig.c
@@ -248,7 +248,7 @@ int __init xbc_node_compose_key_after(st
 			       depth ? "." : "");
 		if (ret < 0)
 			return ret;
-		if (ret > size) {
+		if (ret >= size) {
 			size = 0;
 		} else {
 			size -= ret;
_

Patches currently in -mm which might be from rostedt@goodmis.org are


