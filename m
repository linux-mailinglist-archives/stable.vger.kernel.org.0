Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E067A171C5E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388191AbgB0OLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388688AbgB0OLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FEEC20578;
        Thu, 27 Feb 2020 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812682;
        bh=/tyTvlOefgejlw1qNqg4s5MKur21O+cVuaR95mSgyx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISqdRjUqDog3n7cZUX9IP5BcrMs50Ofv4DAO+GqvHwagB65M58xNgqjoxeh0rNdEC
         ov/qExun0rqSJRH19y76roCGE4xHEi7hgoP6KI2JDnbyCNP56quqioAtmgDHJtLiTR
         G2fsJ3yilDrkSuD+7tHJuATf1BjinEuGBfPqwu30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vaibhav Agarwal <vaibhav.sr@gmail.com>
Subject: [PATCH 5.4 112/135] staging: greybus: use after free in gb_audio_manager_remove_all()
Date:   Thu, 27 Feb 2020 14:37:32 +0100
Message-Id: <20200227132246.031633069@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
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
@@ -92,8 +92,8 @@ void gb_audio_manager_remove_all(void)
 
 	list_for_each_entry_safe(module, next, &modules_list, list) {
 		list_del(&module->list);
-		kobject_put(&module->kobj);
 		ida_simple_remove(&module_id, module->id);
+		kobject_put(&module->kobj);
 	}
 
 	is_empty = list_empty(&modules_list);


