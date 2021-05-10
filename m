Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326EB378554
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhEJLAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234111AbhEJKzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 337746188B;
        Mon, 10 May 2021 10:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643436;
        bh=HJQU5DyvW9xduhipoOniHRMWuWAwWg7D4AkVdwbJluA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUAcoG/ZGq8QL8g2Xm5swYt1a5oMAdWR+c7mqlPYGv25lAuf/PFfjgcNOrXSEmdQw
         XsFYPbnzGDSKIvep/EOhfFIFnsQz7+g8aHIAV3zfd8LUJ9OBGkmtFXQD0d3K1ltrl+
         DP0gBkBbeLGTS7G2NhLoOJ0Brry6WMEFjj8lE18Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Langsdorf <mlangsdo@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 015/342] ACPI: custom_method: fix a possible memory leak
Date:   Mon, 10 May 2021 12:16:45 +0200
Message-Id: <20210510102010.608533560@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Langsdorf <mlangsdo@redhat.com>

commit 1cfd8956437f842836e8a066b40d1ec2fc01f13e upstream.

In cm_write(), if the 'buf' is allocated memory but not fully consumed,
it is possible to reallocate the buffer without freeing it by passing
'*ppos' as 0 on a subsequent call.

Add an explicit kfree() before kzalloc() to prevent the possible memory
leak.

Fixes: 526b4af47f44 ("ACPI: Split out custom_method functionality into an own driver")
Signed-off-by: Mark Langsdorf <mlangsdo@redhat.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/custom_method.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -42,6 +42,8 @@ static ssize_t cm_write(struct file *fil
 				   sizeof(struct acpi_table_header)))
 			return -EFAULT;
 		uncopied_bytes = max_size = table.length;
+		/* make sure the buf is not allocated */
+		kfree(buf);
 		buf = kzalloc(max_size, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;


