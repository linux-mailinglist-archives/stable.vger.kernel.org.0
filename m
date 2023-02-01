Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6091686A1B
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 16:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjBAPWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 10:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbjBAPWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 10:22:14 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90D56E41C;
        Wed,  1 Feb 2023 07:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=wD8siuOqPy8QdM3QhALWZ11+ViYWKi90WD+pfYmy/iI=; b=KDRiPsB4l7vlyNgmQGn/FdBLGe
        TqLeq8QfqbZxqIR4FD8MEUNXeEuKFtD1jFiUAAb9ZHCvCmTFEt9dCx0O6cjcweQpgChlJzbAZRNYn
        sHFXC1jYLJ4xCFem9u7LFgB0h1pP3yvodW0XTMD6IV13WA/qQz79ycYwxMt9uk0cWTfCFf4p5tzL1
        RDD7bRvkp6HbsTel59egxjAsWbGQk6H07t/RBqh4X9/8aEZ79yznoH+nKmpkHp/phK5+5FmrTE9/w
        G3adpt/xOaVfZP/sbFIhQIughfVq/nB09mGI6pU6VqdPAHV011ZLdQ7HslAjc8U62J94p72A1u2pS
        Y9GdHRR0Cv/iv3o6EdzAQm8EB7XBdkwCtk18oyQG+CUXyLEp/lVpBclo5e+4fiwTPmXnZpD/qy+3W
        SkeA+nEQ4GN4GCsL+kHobvojOnkjdrrM3i7fKe29Ig61x9BQBhN+erRf0KGuBpjbb9gWu/uiZl6S2
        ziI0VipR9eifObBEPBv+ylo4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNEvl-00BFZO-Gs; Wed, 01 Feb 2023 15:21:49 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 0/3] avoid plaintext rdma offload if encryption is required
Date:   Wed,  1 Feb 2023 16:21:38 +0100
Message-Id: <cover.1675264648.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think it is a security problem to send confidential data in plaintext
over the wire, so we should avoid doing that even if rdma is in use.

We already have a similar check to prevent data integrity problems
for rdma offload.

Modern Windows servers support signed and encrypted rdma offload,
but we don't support this yet...

Changes v2:
- Added missing Cc: list on commit 2/3

Stefan Metzmacher (3):
  cifs: introduce cifs_io_parms in smb2_async_writev()
  cifs: split out smb3_use_rdma_offload() helper
  cifs: don't try to use rdma offload on encrypted connections

 fs/cifs/smb2pdu.c | 89 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 70 insertions(+), 19 deletions(-)

-- 
2.34.1

