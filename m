Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120C75804DC
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 21:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiGYTxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 15:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiGYTx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 15:53:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 021B920BF9
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 12:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658778806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SJQhmqiMZBrx3tTfrS58fU8YO/57ZJ5gxxWDAo642mA=;
        b=UVpSfrk5vlW+EglR9DKm2tl/QudfvNUzL3i5cinbLx0mO2UK/Io6SWV8L3cd7iukYK10Za
        R6hQfi0xsqN4ofQJXFEpuLyzO5tXkCa4iJ9KfEg15qIoZB+lSUJ5Hh32WJjDJNuw9eDt/G
        DjNAhsMxqrEc5QtTiAwh/7jlEaiXOZg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-kdCVcar-M8O8nYPIKudOWw-1; Mon, 25 Jul 2022 15:53:25 -0400
X-MC-Unique: kdCVcar-M8O8nYPIKudOWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D3D8101A54E
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:53:25 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 162B92026D07;
        Mon, 25 Jul 2022 19:53:25 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCHv2 dlm/next 0/2] fs: dlm: some callback and lowcomm fixes
Date:   Mon, 25 Jul 2022 15:53:20 -0400
Message-Id: <20220725195322.857226-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

