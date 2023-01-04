Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925B765D87B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239907AbjADQPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239890AbjADQPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:15:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4D64435E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88396B81730
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BC3C433D2;
        Wed,  4 Jan 2023 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848868;
        bh=CUwc3TW7fPW6dLhAhrnG5WSaRE9Ls/lIViyVbBw5HFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBt4Oe1jPuzXocX/GUT27Xltb+06Eud+tYTpa8Hcm/5U79jS5uY2DmlKrIiwECFqo
         wUIVYjxueKcTNgHm+MCMS2iUEMi+h96MtEfWr7tXuLIHvd5JcuuWEot/CpD+7Dldde
         UCe6KxdMKMguI1ck+vYi1NWMDbge8T9rf30phwc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.0 027/177] selftests: Use optional USERCFLAGS and USERLDFLAGS
Date:   Wed,  4 Jan 2023 17:05:18 +0100
Message-Id: <20230104160508.488464558@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@digikod.net>

commit de3ee3f63400a23954e7c1ad1cb8c20f29ab6fe3 upstream.

This change enables to extend CFLAGS and LDFLAGS from command line, e.g.
to extend compiler checks: make USERCFLAGS=-Werror USERLDFLAGS=-static

USERCFLAGS and USERLDFLAGS are documented in
Documentation/kbuild/makefiles.rst and Documentation/kbuild/kbuild.rst

This should be backported (down to 5.10) to improve previous kernel
versions testing as well.

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20220909103901.1503436-1-mic@digikod.net
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/lib.mk |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -123,6 +123,11 @@ endef
 clean:
 	$(CLEAN)
 
+# Enables to extend CFLAGS and LDFLAGS from command line, e.g.
+# make USERCFLAGS=-Werror USERLDFLAGS=-static
+CFLAGS += $(USERCFLAGS)
+LDFLAGS += $(USERLDFLAGS)
+
 # When make O= with kselftest target from main level
 # the following aren't defined.
 #


