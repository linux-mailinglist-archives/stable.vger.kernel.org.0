Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA555D5CC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiF0GrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiF0GrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:47:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7AE559E;
        Sun, 26 Jun 2022 23:47:17 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o16so11564188wra.4;
        Sun, 26 Jun 2022 23:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rlLJigxsmTZtJ4R8DtANGAf44bp6QS5yoCTt0RR5Z8=;
        b=azQBxq+JRPZzhixrRay/sYX7W15FYm3yE32ZGqtcODe3saCGAUwtHhvEpAOw8eBDbe
         qF3rs8w5NA1QEHCHFC0hPMADCkVtpz8mT0BtbaWYqQv82IvZhWUQmmizFDKvEMa3wfhM
         AvrTVXibefxwg4jOrCMdJGYjjDbqt7HjtzvzSrpyOXnAMYcOSVekVxgPlz+v8TVgItjy
         veC9uK93EtUEAmkzTuMi3Bc7ztp033LHgdPTJtdIW8opb0nykP7X8Dw/A1G9TREa+FDe
         Ku2r1+DCRa1qw78vwUtusSha5YHNjVV5Uy+FYlLG9CU8/VuznQ4bRDkDr9c52ItdmOD8
         dXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rlLJigxsmTZtJ4R8DtANGAf44bp6QS5yoCTt0RR5Z8=;
        b=zPaQqnNrExnnl+t3cOSW5Tb/0LwMtOMn1Z4o0P1RRCLctsrWpk1ZDfPSHAjeTHdtlb
         mfXOnzeAfgdF7fNIj3r7TmJrSfoRFJOBpacc3cxmIKQTRBUxk3bRX3SQkt0Orny5KLIY
         y5TUibjFRVS5j9ibSnW6JyaXSe/e4Z3iAdviEAwDrnY1PYAsNpawELYvo/5keL7Eb0OU
         RSjt4aE5zO3TJZIboD/Wv4whf/dH0Llue/rhN3fB6LBt34Oo//ygLYXMTEKVdDT2LLMw
         2kRs4H+K0mc+b3ovVhG8mqlQTQTzmTOZi/QotkG934T8RzWNslMQuMpaFWOg7SkMhAEZ
         QS9A==
X-Gm-Message-State: AJIora9R4ph/Mqp//HL98rmDjWCLkfY7/rjc/Ep2qMXxI7j3IfIzcWJW
        YcL1yLwCeU7xz6XYKZK9ZCxLXKSvUpCEig==
X-Google-Smtp-Source: AGRyM1sHBr2FsJlg+WcCol6dfdleKKW0y13uswvIN7A+/s9lpGS9j+yVyAwnYIKiMVCYX3DTLQWlaA==
X-Received: by 2002:a5d:6711:0:b0:21b:9e35:fc91 with SMTP id o17-20020a5d6711000000b0021b9e35fc91mr10695568wru.19.1656312436444;
        Sun, 26 Jun 2022 23:47:16 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm16460839wmq.26.2022.06.26.23.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:47:15 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v3 5/5] xfs: check sb_meta_uuid for dabuf buffer recovery
Date:   Mon, 27 Jun 2022 09:47:03 +0300
Message-Id: <20220627064703.2798133-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627064703.2798133-1-amir73il@gmail.com>
References: <20220627064703.2798133-1-amir73il@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

commit 09654ed8a18cfd45027a67d6cbca45c9ea54feab upstream.

Got a report that a repeated crash test of a container host would
eventually fail with a log recovery error preventing the system from
mounting the root filesystem. It manifested as a directory leaf node
corruption on writeback like so:

 XFS (loop0): Mounting V5 Filesystem
 XFS (loop0): Starting recovery (logdev: internal)
 XFS (loop0): Metadata corruption detected at xfs_dir3_leaf_check_int+0x99/0xf0, xfs_dir3_leaf1 block 0x12faa158
 XFS (loop0): Unmount and run xfs_repair
 XFS (loop0): First 128 bytes of corrupted metadata buffer:
 00000000: 00 00 00 00 00 00 00 00 3d f1 00 00 e1 9e d5 8b  ........=.......
 00000010: 00 00 00 00 12 fa a1 58 00 00 00 29 00 00 1b cc  .......X...)....
 00000020: 91 06 78 ff f7 7e 4a 7d 8d 53 86 f2 ac 47 a8 23  ..x..~J}.S...G.#
 00000030: 00 00 00 00 17 e0 00 80 00 43 00 00 00 00 00 00  .........C......
 00000040: 00 00 00 2e 00 00 00 08 00 00 17 2e 00 00 00 0a  ................
 00000050: 02 35 79 83 00 00 00 30 04 d3 b4 80 00 00 01 50  .5y....0.......P
 00000060: 08 40 95 7f 00 00 02 98 08 41 fe b7 00 00 02 d4  .@.......A......
 00000070: 0d 62 ef a7 00 00 01 f2 14 50 21 41 00 00 00 0c  .b.......P!A....
 XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_buf.c:1514).  Shutting down.
 XFS (loop0): Please unmount the filesystem and rectify the problem(s)
 XFS (loop0): log mount/recovery failed: error -117
 XFS (loop0): log mount failed

Tracing indicated that we were recovering changes from a transaction
at LSN 0x29/0x1c16 into a buffer that had an LSN of 0x29/0x1d57.
That is, log recovery was overwriting a buffer with newer changes on
disk than was in the transaction. Tracing indicated that we were
hitting the "recovery immediately" case in
xfs_buf_log_recovery_lsn(), and hence it was ignoring the LSN in the
buffer.

The code was extracting the LSN correctly, then ignoring it because
the UUID in the buffer did not match the superblock UUID. The
problem arises because the UUID check uses the wrong UUID - it
should be checking the sb_meta_uuid, not sb_uuid. This filesystem
has sb_uuid != sb_meta_uuid (which is fine), and the buffer has the
correct matching sb_meta_uuid in it, it's just the code checked it
against the wrong superblock uuid.

The is no corruption in the filesystem, and failing to recover the
buffer due to a write verifier failure means the recovery bug did
not propagate the corruption to disk. Hence there is no corruption
before or after this bug has manifested, the impact is limited
simply to an unmountable filesystem....

This was missed back in 2015 during an audit of incorrect sb_uuid
usage that resulted in commit fcfbe2c4ef42 ("xfs: log recovery needs
to validate against sb_meta_uuid") that fixed the magic32 buffers to
validate against sb_meta_uuid instead of sb_uuid. It missed the
magicda buffers....

Fixes: ce748eaa65f2 ("xfs: create new metadata UUID field and incompat flag")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d44e8b4a3391..1d649462d731 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -805,7 +805,7 @@ xlog_recover_get_buf_lsn(
 	}
 
 	if (lsn != (xfs_lsn_t)-1) {
-		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
 	}
-- 
2.25.1

