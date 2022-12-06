Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E5C644DA7
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 22:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiLFVCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 16:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLFVCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 16:02:06 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F66B45EE9;
        Tue,  6 Dec 2022 13:02:05 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2B6L1sU5001527
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 6 Dec 2022 16:01:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1670360516; bh=ODQvcrPTn9RADyagdb6ol57IAff8wz0X0HXgGWqOtU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=K95iNMJtkNVJ44MzIxkjQFvmjyBdSxFHt06ONmBKvz1ym/QW0NPJg/dTnayuQd09e
         8ZnQw7ujaJA6YrSyJ0Tds+/fMI4oyZx4uYiU/+P+3eSkEuwZREO0xLT6YucbROr+Fj
         gLJ6v8CDAVB0VXjdKOHdYLfq12u8vyIZQYO+LX6EHSjL5CkmeVG5RP4mKSKMQo81Ir
         c3NKM2GV+LHm4ecSlVW9WRePw4pN2TsU/40Ngepj5wud6R1cLdxNqWsy6vATL+6g7g
         vcmzSrA3S+nypwhLP9iP1lR6BcSLFh1pmkgXH2MFLn/ZWy50LyMEBrzR+BIpVvYl52
         sh8wBkPSyNIuA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D3F5715C39E4; Tue,  6 Dec 2022 16:01:54 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        syzbot+ba9dac45bc76c490b7c3@syzkaller.appspotmail.com,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: don't allow journal inode to have encrypt flag
Date:   Tue,  6 Dec 2022 16:01:48 -0500
Message-Id: <167036049593.156498.14603526492088665546.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20221102053312.189962-1-ebiggers@kernel.org>
References: <20221102053312.189962-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Nov 2022 22:33:12 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Mounting a filesystem whose journal inode has the encrypt flag causes a
> NULL dereference in fscrypt_limit_io_blocks() when the 'inlinecrypt'
> mount option is used.
> 
> The problem is that when jbd2_journal_init_inode() calls bmap(), it
> eventually finds its way into ext4_iomap_begin(), which calls
> fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks() requires that if
> the inode is encrypted, then its encryption key must already be set up.
> That's not the case here, since the journal inode is never "opened" like
> a normal file would be.  Hence the crash.
> 
> [...]

Applied, thanks!

[1/1] ext4: don't allow journal inode to have encrypt flag
      commit: 29cef51d8522c4d8953856afaffcaf1b754e4f6c

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
