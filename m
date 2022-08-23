Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C159D343
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242073AbiHWIMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242013AbiHWIK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E2726E2;
        Tue, 23 Aug 2022 01:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F472610AA;
        Tue, 23 Aug 2022 08:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119ECC433D6;
        Tue, 23 Aug 2022 08:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242024;
        bh=uPEDf+H+9p9j/UybwHupxb1s2C5Sf1klNm8f8v4Kf9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EO4HxgJyQ47HBDvudo5QRRhUgSSjNNXvIkyXh7+Rkmk5Fkp5o7EUd8Zy0a3oRNKCk
         csrQZREEXzFlCBeUmBOHx1wB1PyZlb5WE2SsJMtKBgRRLyNAongPFDQA9B8SxVqKoX
         y0u3PF8ky/dxhn44g+OOJeXYZwEztDrjUMpIePAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.19 047/365] apparmor: fix reference count leak in aa_pivotroot()
Date:   Tue, 23 Aug 2022 09:59:08 +0200
Message-Id: <20220823080120.151196726@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -719,6 +719,7 @@ int aa_pivotroot(struct aa_label *label,
 			aa_put_label(target);
 			goto out;
 		}
+		aa_put_label(target);
 	} else
 		/* already audited error */
 		error = PTR_ERR(target);


