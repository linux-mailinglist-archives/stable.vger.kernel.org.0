Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A804E8A49
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 23:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiC0Vqq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 27 Mar 2022 17:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC0Vqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 17:46:45 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C29812608
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 14:45:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id EC5C2140307;
        Sun, 27 Mar 2022 23:45:04 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id dy32lniuJUHV; Sun, 27 Mar 2022 23:44:59 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 80A84141186;
        Sun, 27 Mar 2022 23:44:59 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 2CA991C9DF0; Sun, 27 Mar 2022 23:44:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id 297F71C9DEF;
        Sun, 27 Mar 2022 23:44:59 +0200 (CEST)
Date:   Sun, 27 Mar 2022 23:44:59 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vlad Buslov <vladbu@mellanox.com>, stable@vger.kernel.org
cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>, Daniel.Fleischer@orbit.de,
        Marcel.Krause@orbit.de, christian.hampe@telekom.de,
        haye.haehne@telekom.de, keith.lloyd@telekom.de
Subject: Re: v4.19.221 breaks qdisc modules
In-Reply-To: <919153d5-a79a-de71-9584-10179ae586d@tarent.de>
Message-ID: <425d1b7-abb9-903c-4ae4-11f27ef06313@tarent.de>
References: <919153d5-a79a-de71-9584-10179ae586d@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 27 Mar 2022, Thorsten Glaser wrote:

> But this makes it more tricky… or can I “just” change this
> to KERNEL_VERSION(4, 19, 221) ?

Well, of course not:

$ cat /usr/src/linux-headers-4.19.0-19-amd64/include/generated/uapi/linux/version.h
#define LINUX_VERSION_CODE 267263
#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
$ print $(((267263 >> 16) & 0xFF)).$(((267263 >> 8) & 0xFF)).$((267263 & 0xFF))
4.19.255

Whose bright idea was *that*?

How can I make this module compatible with *both* 4.19 variants?

Thanks in advance,
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
