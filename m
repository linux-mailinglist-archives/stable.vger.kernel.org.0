Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6411C4DBADD
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 00:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbiCPXQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 19:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236817AbiCPXQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 19:16:27 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5615260C
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:15:12 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4KJmMb3tsyz9sS0;
        Thu, 17 Mar 2022 00:15:07 +0100 (CET)
Message-ID: <016f5ea6-f695-6994-c2ec-35cfef26058a@hauke-m.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1647472505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9fzZ4cJpMCJ/wo08N1/KbgM56vXyh9RzncojaL0AiFk=;
        b=GxDlSg6ADvK4FBXKs6XU5bAe+vQPz9Pq1++3La8XPUVr/P0mp3Vj9EQHbLOhYKctuP0QUK
        jjGb5APBcMPwtWBIeZaSU8x8zfdcVHQP4XbrDDNJe0SFIlOzCfBoWYlnua4sFvFV4W+Q2J
        hFKBiH6YuGF9iXY00s5gErakORtkbV9TWv/Hbx4zofE8+1ay3zk5GMwUgPzleX1zsU2p71
        ELhNDkWKk/bJyLAl2cx+0ATSmn8E8Ly3FKvnHWIfO5FjmY5Vqw2on6Hj8sA9AlQdv5NYwh
        oBUGX4zMkI2q1OQVOJlNCyYDavChHIU7yYbp6uwb/GdsiSRaxSwI7O5UmDs41Q==
Date:   Thu, 17 Mar 2022 00:15:02 +0100
MIME-Version: 1.0
Content-Language: en-US
To:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Add LINUX_VERSION_SUBLEVEL to linux/version.h in LTS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Upstream kernel commit 88a686728b37 ("kbuild: simplify access to the 
kernel's version") [0] extended the Makefile to add the following 
defines to the linux/version.h file:
#define LINUX_VERSION_MAJOR $(VERSION)
#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL)
#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)

I would like to have these defines especially LINUX_VERSION_SUBLEVEL 
also in older stable kernel versions to make it easier for out of tree 
kernel code to detect which version it is compiling against.

In the Linux drivers backports project [1] we backport the current wifi 
driver to older Linux versions, so someone with an old kernel can use 
current wifi drivers. To make this work we have to know which kernel 
version it is being compiled against. The Makefile has access to the 
SUBLEVEL variable and can also forward it to the C code, but this does 
not work when someone compiles some other driver against the mac80211 
subsystem provided by backports for example.

I tried to cherry-pick commit 88a686728b37 to kernel 4.9, but it did not 
apply cleanly. Would it get accepted when I just port the changes in the 
main Makefile to the currently supported LTS kernel versions?

Hauke

[0]: https://git.kernel.org/linus/88a686728b3739d3598851e729c0e81f194e5c53
[1]: https://backports.wiki.kernel.org/index.php/Main_Page


Here would be my suggestion for kernel 4.9, I haven't tested this yet:
--- a/Makefile
+++ b/Makefile
@@ -1142,7 +1142,10 @@ endef
  define filechk_version.h
  	(echo \#define LINUX_VERSION_CODE $(shell                         \
  	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
-	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
+	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) \
+	echo \#define LINUX_VERSION_MAJOR $(VERSION);                    \
+	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL);            \
+	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)
  endef

  $(version_h): $(srctree)/Makefile FORCE
