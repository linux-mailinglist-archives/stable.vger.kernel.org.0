Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4554654994A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiFMQuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 12:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241536AbiFMQt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 12:49:58 -0400
X-Greylist: delayed 323 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Jun 2022 07:36:02 PDT
Received: from rp02.intra2net.com (rp02.intra2net.com [62.75.181.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8977F1EBEF7
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:36:02 -0700 (PDT)
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 08C5A100159;
        Mon, 13 Jun 2022 16:30:37 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id D11CD7D7;
        Mon, 13 Jun 2022 16:30:36 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.64.160,VDF=8.19.17.200)
X-Spam-Status: 
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 128D35FA;
        Mon, 13 Jun 2022 16:30:35 +0200 (CEST)
Date:   Mon, 13 Jun 2022 16:30:34 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Michal Kubecek <mkubecek@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [REGRESSION] v4.19.245: IPSec broken. Fix queued for v4.19.247
Message-ID: <20220613143034.wbz7kqmijc5b5ge7@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi kernel stable team,

I want to report a regression in v4.19.245 / v4.19.246 in case someone else
also hits this: strongswan 4.6 errors out with an assertion:

Jun 13 08:55:02 mis1 pluto[4096]: "C1"[1] 10.2.0.1:10954 #2: ASSERTION FAILED at ipsec_doi.c:2852: case 3 unexpected
(the source line number is not relevant due to extra patches)

-> Our automated distro testsuite had IPSec related VPN test failures.

A fix for the issue is queued for v4.19.247 already:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-4.19/revert-net-af_key-add-check-for-pfkey_broadcast-in-f.patch?id=ef7f0fb363ccf5f9890080db89412b9f0bd7650a
'Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"'

From the commit message of the revert:

**********************************
"One visible effect is that racoon daemon fails to find encryption
algorithms like aes and refuses to start."
**********************************

For the older strongwan 4.6 "pluto" daemon the problem showed itself
at a later stage during phase 2 of an IPSec tunnel setup.


Thanks for the great work on the stable kernel!
Regressions are a rare thing these days.

Best regards,
Thomas Jarosch
