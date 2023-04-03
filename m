Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85F06D46AF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjDCOMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbjDCOMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:12:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39582C9EA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5574CB81B2B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B326DC433EF;
        Mon,  3 Apr 2023 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531140;
        bh=SiYvIlSb5hLINzvc1t1fWbTTA1GTe6jQxNPXyDmAGtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+/6SpOX1NcTwl2XDnD/W5JDGm9sdiGn9jUit1vGapwwlvacgP9HATET3H9tjiKZI
         cliiG3BMNjdbNtE5wZZPrEPHWdJDUZ2YdqLs5er3eQO4MOJJaSsIMQziWgK3w+IaKC
         c1Rzb0NRAxtnfdAzAYXSx+mQ6G/ViCh/PZdZljLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Chen <peter.chen@kernel.org>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 4.14 34/66] usb: chipdea: core: fix return -EINVAL if request role is the same with current role
Date:   Mon,  3 Apr 2023 16:08:42 +0200
Message-Id: <20230403140353.094274413@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit 3670de80678961eda7fa2220883fc77c16868951 upstream.

It should not return -EINVAL if the request role is the same with current
role, return non-error and without do anything instead.

Fixes: a932a8041ff9 ("usb: chipidea: core: add sysfs group")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20230317061516.2451728-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -875,9 +875,12 @@ static ssize_t ci_role_store(struct devi
 			     strlen(ci->roles[role]->name)))
 			break;
 
-	if (role == CI_ROLE_END || role == ci->role)
+	if (role == CI_ROLE_END)
 		return -EINVAL;
 
+	if (role == ci->role)
+		return n;
+
 	pm_runtime_get_sync(dev);
 	disable_irq(ci->irq);
 	ci_role_stop(ci);


