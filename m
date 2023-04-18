Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DE16E6239
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjDRMbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjDRMaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5283C650
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A74C46315A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB77C433EF;
        Tue, 18 Apr 2023 12:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821035;
        bh=6XhEvYrJCTz1ciT2/7zgYjLxhKowSkg9Bsv+rqrzEZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItxwECczqvX3kxR3ZB+sMywC/1vKtQqf1xVdvfkzIBw8YrRT6uDcC1kTwjUpHrOlg
         58HtvHz5lm3ceiIV8CDz7ZwZQtn/nHFJjng3zco83+l/oXqhbL30ImswLIJRfHNt/E
         /5oCNRW7C0iCrKV6u005MDTbqM2gSFMZTo3//Q/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 5.4 37/92] net_sched: prevent NULL dereference if default qdisc setup failed
Date:   Tue, 18 Apr 2023 14:21:12 +0200
Message-Id: <20230418120306.139900500@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pratyush Yadav <ptyadav@amazon.de>

If qdisc_create_dflt() fails, it returns NULL. With CONFIG_NET_SCHED
enabled, the check qdisc != &noop_qdisc passes and qdisc will be passed
to qdisc_hash_add(), which dereferences it.

This assignment was present in the upstream commit 5891cd5ec46c2
("net_sched: add __rcu annotation to netdev->qdisc") but was missed in
the backport 22d95b5449249 ("net_sched: add __rcu annotation to
netdev->qdisc"), perhaps due to merge conflicts.  dev->qdisc is
&noop_qdisc by default and if qdisc_create_dflt() fails, this assignment
will make sure qdisc == &noop_qdisc and no NULL dereference will take
place.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 22d95b5449249 ("net_sched: add __rcu annotation to netdev->qdisc")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1116,6 +1116,7 @@ static void attach_default_qdiscs(struct
 			qdisc->ops->attach(qdisc);
 		}
 	}
+	qdisc = rtnl_dereference(dev->qdisc);
 
 #ifdef CONFIG_NET_SCHED
 	if (qdisc != &noop_qdisc)


