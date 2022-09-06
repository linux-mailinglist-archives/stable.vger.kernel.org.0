Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89FB5AEAC9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbiIFNz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240326AbiIFNyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:54:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5E880F41;
        Tue,  6 Sep 2022 06:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50CBF61539;
        Tue,  6 Sep 2022 13:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B817C433D7;
        Tue,  6 Sep 2022 13:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471688;
        bh=Zhjxdo+O3YDSRG51bQSs5A+7FtpAQPLDxhfGV13A5s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAQ71TXZFq4KEFXeHYwIY5eYZnesqPwTLWWDh/Ch1pwijbbw2VZ74RGAOkYTI1j3N
         KZXAHO1C0Yupjh5oTC4xPQUojft9EjdABRqJqOaipUEUkv9xF+ujNZaHvn6WRHwEoO
         uewr7sMsaRKJiuAsePgRWKzw7b3pF4YTPP/Y6dA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5.15 102/107] kbuild: Add skip_encoding_btf_enum64 option to pahole
Date:   Tue,  6 Sep 2022 15:31:23 +0200
Message-Id: <20220906132826.180891759@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>

New pahole (version 1.24) generates by default new BTF_KIND_ENUM64 BTF tag,
which is not supported by stable kernel.

As a result the kernel with CONFIG_DEBUG_INFO_BTF option will fail to
compile with following error:

  BTFIDS  vmlinux
FAILED: load BTF from vmlinux: Invalid argument

New pahole provides --skip_encoding_btf_enum64 option to skip BTF_KIND_ENUM64
generation and produce BTF supported by stable kernel.

Adding this option to scripts/pahole-flags.sh.

This change does not have equivalent commit in linus tree, because linus tree
has support for BTF_KIND_ENUM64 tag, so it does not need to be disabled.

Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/pahole-flags.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -17,4 +17,8 @@ if [ "${pahole_ver}" -ge "121" ]; then
 	extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
 fi
 
+if [ "${pahole_ver}" -ge "124" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
+fi
+
 echo ${extra_paholeopt}


