Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73506280FE
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiKNNOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbiKNNOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:14:15 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1DCFF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:14:14 -0800 (PST)
Date:   Mon, 14 Nov 2022 22:14:03 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668431652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gJtH7eyHg+nyt/FfzIWraxGvBmhas+9WwFNfKCXO88s=;
        b=EqMaIm5myxWft5/idBWpk1Rjxwr2+cLjtqtR6ElTy6bkTe/1nydF8h5d8tT7o4KUHZLVNX
        W/gO07H3hzL76x2KQsZLlYD8nOYUz+/BQ3gzC6QvUZHpS7EWmySXkD5sIQgBY2UOV37EIm
        56ufru+71nmq/9ktfMmN2mKdqDI02c0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     stable@vger.kernel.org
Cc:     Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <20221114131403.GA3807058@u2004>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'd like to request the follow commits to be backported to 5.15.y.

- dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
- 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
- a76054266661 ("mm: shmem: don't truncate page if memory failure happens")

These patches fixed a data lost issue by preventing shmem pagecache from
being removed by memory error.  These were not tagged for stable originally,
but that's revisited recently.

Thanks,
Naoya Horiguchi
