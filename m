Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC59F67C677
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 09:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbjAZI7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 03:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbjAZI7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 03:59:35 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DEA66039;
        Thu, 26 Jan 2023 00:59:34 -0800 (PST)
Received: from fedcomp.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 6F45844C1015;
        Thu, 26 Jan 2023 08:59:28 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 6F45844C1015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1674723568;
        bh=7UfwmOWHFt6a/8Ex+qRvbVWeg3/58uB3TqPEaIYkyQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=qcf/mdeb2Xa3/xVWW7JkFng9jZyiiobKzqheQRaW8UZK92Gx8xAPJzWxoJ3YvCM1c
         MbPB1Y6geeh6rLAup/BPbTDJ7JIdooGWEBLFN8xpc3wfxy+KnINLjRwinb4ydfVh8w
         wPZaGrQ4fk3pkczCsoNsn1TMr7gNiP6UiFr3mqoU=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Jan Kara <jack@suse.cz>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 4.14/4.19/5.4/5.10/5.15 0/1] fs: reiserfs: remove useless new_opts in reiserfs_remount
Date:   Thu, 26 Jan 2023 11:58:45 +0300
Message-Id: <20230126085846.466209-1-pchelkin@ispras.ru>
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

As described in the following commit info, new_opts value is not used
anymore and is not cleaned on non-error paths -- it is a leak. The problem
has been fixed by the following patch which can be cleanly applied
to 4.14, 4.19, 5.4, 5.10, 5.15 branches.
