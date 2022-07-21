Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B237757D64B
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbiGUVx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiGUVxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:53:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 636E892846
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 14:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658440432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IUfAq6zGEfHyLcp/TKUpOtwfJo5pu7OT1SEaV7e3QOI=;
        b=a8e0cqcdj6AzLjxL44kLKggrzc31rerPdZnPT0bNR7DE6FlxUw/lk8v3CjbTg2+kBsEbF/
        RDV0HSYG/GdoFXtDg7GIwK1TqsR6YeQzoZ7P3a/1LnXxkom1Lo/bvT/Z6PPBHjLRIdkdtt
        AHk+zGJfFK6aNbC7+8i+z2cRJ4S04rY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-uA_yy5bEMdCog63xzBGg6A-1; Thu, 21 Jul 2022 17:53:50 -0400
X-MC-Unique: uA_yy5bEMdCog63xzBGg6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69BA2185A7B2
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 21:53:50 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 415B02026D64;
        Thu, 21 Jul 2022 21:53:50 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 0/3] fs: dlm: some callback fixes
Date:   Thu, 21 Jul 2022 17:53:37 -0400
Message-Id: <20220721215340.936838-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I currently look a little bit deeper into the callback handling of dlm
and I think we have some issues there. Especially with the refcounting
and queue_work() per lkb. I have some local branches which does more
some rework and moving away from the lkb_callbacks[] array per lkb and
using a queue for handling callbacks. However those are issues which I
currently found for now and should be fixed.

- Alex

Alexander Aring (3):
  fs: dlm: fix race between test_bit() and queue_work()
  fs: dlm: avoid double list_add() for lkb->lkb_cb_list
  fs: dlm: fix refcount handling for dlm_add_cb()

 fs/dlm/ast.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

-- 
2.31.1

