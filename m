Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E9A526A5A
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbiEMT12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 15:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383944AbiEMT0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 15:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5601339177;
        Fri, 13 May 2022 12:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E709E615DE;
        Fri, 13 May 2022 19:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B43DC34100;
        Fri, 13 May 2022 19:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469820;
        bh=7XedWW1p5KcyMhJBQAruLx9+QGAPeqf+1BVbwbvLa1s=;
        h=Date:To:From:Subject:From;
        b=CKvWgoqn0hLX3FpaYWOjwOi6DCKnkQItukEMOcbL2//aDQaAkTNvRIglUKmFbSueg
         mTD3cinI1xtH3sYP9oIrYEyMrMw5njbOCQXL2UJtHIDSmIsYGqhCGgZeXp5MrJ0lbf
         sLwePkCVDJAVlLITUXmFKjzZr6R9v4q2/+Fg2Ux4=
Date:   Fri, 13 May 2022 12:23:39 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        linus.walleij@linaro.org, andy.shevchenko@gmail.com,
        puyou.lu@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-string_helpers-fix-not-adding-strarray-to-devices-resource-list.patch removed from -mm tree
Message-Id: <20220513192340.4B43DC34100@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: lib/string_helpers: fix not adding strarray to device's resource list
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-fix-not-adding-strarray-to-devices-resource-list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Puyou Lu <puyou.lu@gmail.com>
Subject: lib/string_helpers: fix not adding strarray to device's resource list

Add allocated strarray to device's resource list. This is a must to
automatically release strarray when the device disappears.

Without this fix we have a memory leak in the few drivers which use
devm_kasprintf_strarray().

Link: https://lkml.kernel.org/r/20220506044409.30066-1-puyou.lu@gmail.com
Link: https://lkml.kernel.org/r/20220506073623.2679-1-puyou.lu@gmail.com
Fixes: acdb89b6c87a ("lib/string_helpers: Introduce managed variant of kasprintf_strarray()")
Signed-off-by: Puyou Lu <puyou.lu@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/string_helpers.c~lib-string_helpers-fix-not-adding-strarray-to-devices-resource-list
+++ a/lib/string_helpers.c
@@ -757,6 +757,9 @@ char **devm_kasprintf_strarray(struct de
 		return ERR_PTR(-ENOMEM);
 	}
 
+	ptr->n = n;
+	devres_add(dev, ptr);
+
 	return ptr->array;
 }
 EXPORT_SYMBOL_GPL(devm_kasprintf_strarray);
_

Patches currently in -mm which might be from puyou.lu@gmail.com are


