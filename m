Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC07B59DFC1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356136AbiHWKt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356431AbiHWKrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:47:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F02386B4E;
        Tue, 23 Aug 2022 02:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC13C60DB4;
        Tue, 23 Aug 2022 09:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3A3C433D6;
        Tue, 23 Aug 2022 09:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245910;
        bh=ABq+T4w3fzA7lwyjdCSsJMz1bpZ3rIbr9SCyC8Hlzt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irQ9YFMGUBoZ2sCjyNbIXL+arOqxmHDPU0efhkLXqIgThKKDkdPDpsF+H0xBjU98G
         q8SJjCEMGVKy551d9quoOMrTDRpgv80hzd8/TI4pe5iBhhitqYK+AFQ1MT9Azg+E8A
         ta7+VMQ2nbhJkKDsRMPztlqvuz7Pra7W0vwic3Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.19 228/287] apparmor: fix reference count leak in aa_pivotroot()
Date:   Tue, 23 Aug 2022 10:26:37 +0200
Message-Id: <20220823080108.688336207@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

commit 11c3627ec6b56c1525013f336f41b79a983b4d46 upstream.

The aa_pivotroot() function has a reference counting bug in a specific
path. When aa_replace_current_label() returns on success, the function
forgets to decrement the reference count of “target”, which is
increased earlier by build_pivotroot(), causing a reference leak.

Fix it by decreasing the refcount of “target” in that path.

Fixes: 2ea3ffb7782a ("apparmor: add mount mediation")
Co-developed-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Co-developed-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/mount.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -686,6 +686,7 @@ int aa_pivotroot(struct aa_label *label,
 			aa_put_label(target);
 			goto out;
 		}
+		aa_put_label(target);
 	} else
 		/* already audited error */
 		error = PTR_ERR(target);


