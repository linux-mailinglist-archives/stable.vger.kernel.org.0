Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0541FBA4A
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbgFPPos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732014AbgFPPop (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B196521475;
        Tue, 16 Jun 2020 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322285;
        bh=qTgrEBZKZMWmg0X6f6sF+T8F0d7Vb3RU2qYh7J8sQn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DV3oVv1shjhmPs7ZaDnR46F5yx5P/lxLQTDZ3XsOJL7iAyt1dhjxrBGw50Y+5n0A+
         bgWRHWrZ3iGWTrnhrzI+Sp8etK/IM06PcoyLpOaGEg0QBhzYa+ntdcQ1zasu07FxzM
         Hoac6i9eh5PRPU2bBbN5DjBKuNunNlowcQ/E5+Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.7 073/163] ACPI: CPPC: Fix reference count leak in acpi_cppc_processor_probe()
Date:   Tue, 16 Jun 2020 17:34:07 +0200
Message-Id: <20200616153110.345119998@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit 4d8be4bc94f74bb7d096e1c2e44457b530d5a170 upstream.

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Previous
commit "b8eb718348b8" fixed a similar problem.

Fixes: 158c998ea44b ("ACPI / CPPC: add sysfs support to compute delivered performance")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/cppc_acpi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -846,6 +846,7 @@ int acpi_cppc_processor_probe(struct acp
 			"acpi_cppc");
 	if (ret) {
 		per_cpu(cpc_desc_ptr, pr->id) = NULL;
+		kobject_put(&cpc_ptr->kobj);
 		goto out_free;
 	}
 


