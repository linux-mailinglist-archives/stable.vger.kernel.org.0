Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF42526494
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381111AbiEMOcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381446AbiEMObZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E1E1ACF90;
        Fri, 13 May 2022 07:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 452C2621C6;
        Fri, 13 May 2022 14:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE11C34100;
        Fri, 13 May 2022 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452149;
        bh=xp+u8NygbVxoi99MAWO9qUlTrei9uqsPK0jfOp9gZ8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I63vphraMYnpAhzPWVteJ15I1YtUzcKwW4yfa5JJIBKu+yw0lh5d9VQi9CacBuXAH
         rwHfSgUpUvLMb8QA/PDK031BN/oEfvFrBA2IFdj67V1IE0vRgdh182GrzGdliqLbD2
         4H7yWoTnyQChnJAjbjzCIY7mYKJ6gr4gAexkDcr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.17 02/12] rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition
Date:   Fri, 13 May 2022 16:24:02 +0200
Message-Id: <20220513142228.724371318@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
References: <20220513142228.651822943@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>

commit a36e07dfe6ee71e209383ea9288cd8d1617e14f9 upstream.

The definition of RFKILL_IOCTL_MAX_SIZE introduced by commit
54f586a91532 ("rfkill: make new event layout opt-in") is unusable
since it is based on RFKILL_IOC_EXT_SIZE which has not been defined.
Fix that by replacing the undefined constant with the constant which
is intended to be used in this definition.

Fixes: 54f586a91532 ("rfkill: make new event layout opt-in")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Link: https://lore.kernel.org/r/20220506172454.120319-1-glebfm@altlinux.org
[add commit message provided later by Dmitry]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rfkill.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -184,7 +184,7 @@ struct rfkill_event_ext {
 #define RFKILL_IOC_NOINPUT	1
 #define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
 #define RFKILL_IOC_MAX_SIZE	2
-#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_EXT_SIZE, __u32)
+#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_MAX_SIZE, __u32)
 
 /* and that's all userspace gets */
 


