Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A67559E675
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 18:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244441AbiHWQCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 12:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244210AbiHWQAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 12:00:30 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD3B23DF27;
        Tue, 23 Aug 2022 05:12:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k9so16786154wri.0;
        Tue, 23 Aug 2022 05:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=f8IqA0rpja1ryiZArx8DZuQ4CdrVRu4KVeHRxdOu9GI=;
        b=CsIGt9C4asU+NYNytquhInvoQbT9oe+codzK0OaRlvg2WwtOoSVv7JxzQAPTkzk+XX
         UwLlQ7zasv2ZfdS8Bp/+G9VUL9QwRF6z6teKb/sGjJ51jdzRFCQGhDXPH4lr+KGEs6Gq
         GnRb7ukT6f6xSD6JSe7/xY4IBxupIpJ1ijPKrGGdOk8e6BQO+T/yE0eoJTJtm5E7y+4J
         9GnCWv5jSPBnY3lfYyiwQkYXPePHE0l9LC44A2kkYDwqCQqF3oSQHk1PzkGlFxtrfSzQ
         MJm1bz6M6T1k62Sx6o1AS4qCRskAnfyTv7vm8pyJpsmoPKsUfSDCMTea14aMnWnS5b7N
         shwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=f8IqA0rpja1ryiZArx8DZuQ4CdrVRu4KVeHRxdOu9GI=;
        b=fw6mdA1XCxeVOT/cPEsTh5NvVe3y71aNLCsPrcnvvXkOU3Ai3FZWJCT9AdIMrk3u3I
         U6A2ePQXvjQqEG6VfvV9JbUFi511zgUyKlDCO3FM8YMunpVJSu+pCWwQ6nJqR2SNmlJ7
         jRKMfAvXQ8iAi0+bi/jfuaFUMDcEvHAOHonLyZrVSW+wUQCOp93rDFYzdUSvfwsd9RRY
         OxuHDyTPbVS5xHenOQ18H/UguRvBvkqpnUVb+oKP2j0zEsevFSggGvW0ShuDSt7aPV//
         0WwG5rOu125HYv5aGIoFMrvoIMA4CTG4avZZ1XhD0RybcE7MF6z2TLNtD5PjaADGB4Ap
         GXvw==
X-Gm-Message-State: ACgBeo2dbq2UIp4mkJOdIgYem77CzVOkR40JFW2VFGl/vSn/qLqHQSTN
        Kb7tlRx/WAgmHoTDfmO3oRQ=
X-Google-Smtp-Source: AA6agR7QAecD3Uza+N1Psk5KAyKqmg9ikvTmMDSFLjRdGmzB1CrPo9LKPLKEXJN3YpJrlaWZdlGWng==
X-Received: by 2002:a05:6000:1885:b0:225:5d24:7ccf with SMTP id a5-20020a056000188500b002255d247ccfmr4191966wri.215.1661256710688;
        Tue, 23 Aug 2022 05:11:50 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24681879wmq.6.2022.08.23.05.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:11:50 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 v2 5/6] xfs: return errors in xfs_fs_sync_fs
Date:   Tue, 23 Aug 2022 15:11:35 +0300
Message-Id: <20220823121136.1806820-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823121136.1806820-1-amir73il@gmail.com>
References: <20220823121136.1806820-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2d86293c70750e4331e9616aded33ab6b47c299d upstream.

Now that the VFS will do something with the return values from
->sync_fs, make ours pass on error codes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6323974d6b3e..ff686cb16c7b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -757,6 +757,7 @@ xfs_fs_sync_fs(
 	int			wait)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	int			error;
 
 	/*
 	 * Doing anything during the async pass would be counterproductive.
@@ -764,7 +765,10 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
-	xfs_log_force(mp, XFS_LOG_SYNC);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+
 	if (laptop_mode) {
 		/*
 		 * The disk must be active because we're syncing.
-- 
2.25.1

