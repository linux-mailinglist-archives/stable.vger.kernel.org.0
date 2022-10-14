Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394495FF25A
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJNQj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJNQj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:39:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56E1114DFC;
        Fri, 14 Oct 2022 09:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=BO2vgPdgdXchK2oRtsstbiY0yQprvBApkNKGIMro4U4=; t=1665765566; x=1666975166; 
        b=L47SJMvJa6/XcMR2cIsyr2nRRxevNXK6/oNIacKSx5gL9W6f7bm1vXvjpNKXMLtc+wzVpI1wvK2
        crkUgNLrvTF/o66ZexL708KPMvwk3hGhDMaHpQVCq9eUAekhJuwRg/TWJPHNyVg73zsWd4Mzkp6jH
        fUuxlw6kXz24VLjUixkhgiSACqy9rUtbEhxfgJtFRKjin88h7Seq//gpKNguZELgKGYkxAnEc63yM
        EYjDAGb1ur10CdmHR1u6IWvi6KbGQ122wAsoPr6HHY0g6XgZrQ/OLmmWYw9yFWSoQ5qWiYD3vgIqq
        co5eRVLvjryJifgG8aWfiOC/mVaD1lqy/DAg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNiV-006gmQ-0N;
        Fri, 14 Oct 2022 18:39:23 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>
Subject: [RFC v5.10 0/3] mac80211 use-after-free fix
Date:   Fri, 14 Oct 2022 18:39:03 +0200
Message-Id: <20221014163906.23156-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

So I looked at this, and it wasn't great one way or the other...

The first patch here is obvious, let's just take it and get one
of the parsings out of the way.

The second one removes a couple of more cases where this is done,
since it only happens when the last argument is non-NULL.

The third then is to avoid the UAF, and is simpler now since only
a few places can even allocate it.

johannes


