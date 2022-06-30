Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9043A561BB9
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiF3Ns0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbiF3NsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDCC18E;
        Thu, 30 Jun 2022 06:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B55E361FF5;
        Thu, 30 Jun 2022 13:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E1DC34115;
        Thu, 30 Jun 2022 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596884;
        bh=//tNa/+oXvrh+YZZ1UklDkaYoawaeD35eJmeJbf1BKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=su7wPm8pR+0MYeoa8Kad/ZaXJTEah6z3nyd8vRz2BYJrGKrh3zAhgcE+94/3Fim2R
         ntyhhHrcu0Mk4MrxdyOTeUn4CqolkPWyD5dp+RIqpXC2caPsV+hbpPXIzF3YQWWgN4
         +RBQE3ny26jpAkhr/2LU0Quat+27+7/GEhl7dXxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 4.9 16/29] xtensa: xtfpga: Fix refcount leak bug in setup
Date:   Thu, 30 Jun 2022 15:46:16 +0200
Message-Id: <20220630133231.683305620@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

commit 173940b3ae40114d4179c251a98ee039dc9cd5b3 upstream.

In machine_setup(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Cc: stable@vger.kernel.org
Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220617115323.4046905-1-windhl@126.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/platforms/xtfpga/setup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -152,6 +152,7 @@ static int __init machine_setup(void)
 
 	if ((eth = of_find_compatible_node(eth, NULL, "opencores,ethoc")))
 		update_local_mac(eth);
+	of_node_put(eth);
 	return 0;
 }
 arch_initcall(machine_setup);


