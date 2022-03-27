Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F034E8A48
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 23:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiC0Vqm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 27 Mar 2022 17:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC0Vql (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 17:46:41 -0400
X-Greylist: delayed 341 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Mar 2022 14:45:01 PDT
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2077BF70
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 14:45:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id A60EF141180;
        Sun, 27 Mar 2022 23:39:18 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id BILQMD5ereEZ; Sun, 27 Mar 2022 23:39:13 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 0451C140307;
        Sun, 27 Mar 2022 23:39:10 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 69D1E1C9DF0; Sun, 27 Mar 2022 23:39:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id 65FC41C9DEF;
        Sun, 27 Mar 2022 23:39:10 +0200 (CEST)
Date:   Sun, 27 Mar 2022 23:39:10 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vlad Buslov <vladbu@mellanox.com>, stable@vger.kernel.org
cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: v4.19.221 breaks qdisc modules
Message-ID: <919153d5-a79a-de71-9584-10179ae586d@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_40,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

commit 92833e8b5db6c209e9311ac8c6a44d3bf1856659 breaks the
build of sch_* modules in stable.

I already have:

#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 20, 0)
                qdisc_destroy(cl->leaf.q);
#else
                qdisc_put(cl->leaf.q);
#endif

But this makes it more tricky… or can I “just” change this
to KERNEL_VERSION(4, 19, 221) ?

Nevertheless, renaming functions isn’t something I’d expect
to happen in stable. At least add a #define or so redirecting
from the old/stable name…

bye,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
