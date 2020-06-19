Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86CC201048
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393634AbgFSP2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404578AbgFSP22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92D9B21927;
        Fri, 19 Jun 2020 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580508;
        bh=TVQme5uwrhy0pdFQ+Q9CP9CqmE7FJy1dtheGvgty/Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sE4TarEfY57r/mY1M0nsS/N2uXvF4f6/kOSoOZZGNLTaaL0oUjAThtbk7GDluIF9R
         bxv7xIbsBH7Bzq3IeF1YgyEbjOwBYWFpsQ1irZwcH63PFqcCrhVK6ihh4+KTvOuGkz
         szwsFpyBGNqmujYgH0gZvCYYloGVs9p/Fy0EyJBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.7 275/376] ima: Evaluate error in init_ima()
Date:   Fri, 19 Jun 2020 16:33:13 +0200
Message-Id: <20200619141723.351041873@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit e144d6b265415ddbdc54b3f17f4f95133effa5a8 upstream.

Evaluate error in init_ima() before register_blocking_lsm_notifier() and
return if not zero.

Cc: stable@vger.kernel.org # 5.3.x
Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -792,6 +792,9 @@ static int __init init_ima(void)
 		error = ima_init();
 	}
 
+	if (error)
+		return error;
+
 	error = register_blocking_lsm_notifier(&ima_lsm_policy_notifier);
 	if (error)
 		pr_warn("Couldn't register LSM notifier, error %d\n", error);


