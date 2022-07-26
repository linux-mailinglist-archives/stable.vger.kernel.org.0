Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52526581369
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 14:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiGZMvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 08:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiGZMvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 08:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 490901D30E
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 05:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658839881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B0YgJKO/6cBt0lI/psvdgddps/rE6a1ErVlBqQnFaoI=;
        b=UXOXN/B/O1oZkILCZp1jP9XxCW3OVOTNcKTwXWVEQgOqbO0WB3lQ/p6N8qVLBAgA+TL12O
        I7U8uco0X4b5pioRPuq0MXkv5oTN5bTifblad9KLvN6BPew/dEyvQRLUQGEOgJTILBeOvF
        QHCjFVNiOU9b2txZ80AOK1J/7buH5Gw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-YlnESLqrM-i4HjkljflscQ-1; Tue, 26 Jul 2022 08:51:19 -0400
X-MC-Unique: YlnESLqrM-i4HjkljflscQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A35A7811E76
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 12:51:19 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DEBF492CA4;
        Tue, 26 Jul 2022 12:51:19 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCHv3 dlm/next 0/2] fs: dlm: some callback and lowcomm fixes
Date:   Tue, 26 Jul 2022 08:51:16 -0400
Message-Id: <20220726125118.955056-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I currently look a little bit deeper into the callback handling of dlm.
I have some local branches which does more some rework and moving away
from the lkb_callbacks[] array per lkb and using a queue for handling
callbacks. However those are issues which I currently found for now
and should be fixed.

- Alex

changes since v3:
 - add Fixes tag
 - add Cc: stable

changes since v2:

 - drop patches 2/3 and 3/3 as it looks okay. Sorry about the noise.
 - change commit messages regarding v2 changes.
 - add patch "fs: dlm: fix race in lowcomms"

Alexander Aring (2):
  fs: dlm: fix race in lowcomms
  fs: dlm: fix race between test_bit() and queue_work()

 fs/dlm/ast.c      | 6 ++++--
 fs/dlm/lowcomms.c | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.31.1

