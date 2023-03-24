Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F356C86AA
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 21:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCXUTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 16:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXUTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 16:19:54 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA8190;
        Fri, 24 Mar 2023 13:19:53 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.3])
        by mail.ispras.ru (Postfix) with ESMTPSA id 911D3406BB55;
        Fri, 24 Mar 2023 20:19:48 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 911D3406BB55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1679689188;
        bh=zj2rSWb1TY4pRH2CJrKhLgINCPnlbpAhrLKT1TLUAhQ=;
        h=From:To:Cc:Subject:Date:From;
        b=hcxtWdhx9QiidP8iLi2CC1m18bl6BOovSkmUIT8s+0DIVcNslobCalobZxfLSInP6
         M/9Qm6phVYeHiDOCIkiPNYeJaLgLQts43ruFoe5JlnjWF2adD/PtwDmOq1p3LNcYSj
         IH0BGU7vpeahG8g+QJ7opf/y0H+aznlxGXUUiS6s=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 4.19/5.4/5.10 0/1] gfs2: Always check inode size of inline inodes
Date:   Fri, 24 Mar 2023 23:19:32 +0300
Message-Id: <20230324201933.329885-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel bug in iomap_read_inline_data() fixed by the following patch is hit
on older stables 4.19/5.4/5.10.

The patch failed to be initially backported into stable branches older
than 5.15 due to the upstream commit 7db354444ad8 ("gfs2: Cosmetic
gfs2_dinode_{in,out} cleanup").

Now it can be cleanly applied to the 4.19/5.4/5.10 stable branches.
