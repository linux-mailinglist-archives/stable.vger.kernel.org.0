Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CE9171A38
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgB0Nvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731442AbgB0Nvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:51:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1BC20801;
        Thu, 27 Feb 2020 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811505;
        bh=7+8IUUNeENPExRxQnZqF/iU4d7nSWfX3uixTtff8G+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhsOA/cTkqw9z2SS91IDpmgWJxy7kFLDNISC/LGDTKS123XrAXtuJh2Y8i8a5Pjsr
         A9D9tw+KbA4xYnmDyl1ZvR6BYfH30xo3MVjHEP6eOsFruRHDA+/n5uHXbxVHHFL9Af
         NtuXtDAah9jfWJzCZul365VF1BfNLz93XjeXZuo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vaibhav Agarwal <vaibhav.sr@gmail.com>
Subject: [PATCH 4.9 157/165] staging: greybus: use after free in gb_audio_manager_remove_all()
Date:   Thu, 27 Feb 2020 14:37:11 +0100
Message-Id: <20200227132253.684679849@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b7db58105b80fa9232719c8329b995b3addfab55 upstream.

When we call kobject_put() and it's the last reference to the kobject
then it calls gb_audio_module_release() and frees module.  We dereference
"module" on the next line which is a use after free.

Fixes: c77f85bbc91a ("greybus: audio: Fix incorrect counting of 'ida'")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Vaibhav Agarwal <vaibhav.sr@gmail.com>
Link: https://lore.kernel.org/r/20200205123217.jreendkyxulqsool@kili.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/greybus/audio_manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/greybus/audio_manager.c
+++ b/drivers/staging/greybus/audio_manager.c
@@ -90,8 +90,8 @@ void gb_audio_manager_remove_all(void)
 
 	list_for_each_entry_safe(module, next, &modules_list, list) {
 		list_del(&module->list);
-		kobject_put(&module->kobj);
 		ida_simple_remove(&module_id, module->id);
+		kobject_put(&module->kobj);
 	}
 
 	is_empty = list_empty(&modules_list);


