Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E262466AE45
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 23:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjANW11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 17:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjANW1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 17:27:23 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC049EF7;
        Sat, 14 Jan 2023 14:27:23 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2C31140737AF;
        Sat, 14 Jan 2023 22:27:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 2C31140737AF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1673735241;
        bh=4ClNmtCZQgfd2qu77TAQYOQT0Giru88nRwPxaxDudJc=;
        h=From:To:Cc:Subject:Date:From;
        b=gKY6mqi7zXoj0AnbmSqXAAVyD79EfKbGs21JzEqpodSnfIV2drGcN+tFZeLSNfCOQ
         R3n8X/5jAK/YYUXyBBA7Q2J6hpddOzR/VOaQsFepr918qXrFWslfDz/wPVU9wfL1h1
         t1waWdl/SW9+4kFjZ3L3tWQIB8A7AZojI2Ptadyw=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] block: replace WARN_ONCE with pr_warn in bio_check_ro
Date:   Sun, 15 Jan 2023 01:27:08 +0300
Message-Id: <20230114222709.180795-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzkaller reports warning in submit_bio_checks in 5.10 stable releases.
The issue has been fixed by the following patch which can be cleanly
applied to 5.10 branch.

bio->bi_bdev from original patch is not compatible with 5.10 so adapted
the print message to work with 5.10 cleanly.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
