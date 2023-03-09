Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505026B205E
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 10:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjCIJnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 04:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjCIJnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 04:43:03 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789102D7B;
        Thu,  9 Mar 2023 01:42:54 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id f11so1203637wrv.8;
        Thu, 09 Mar 2023 01:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678354972;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wuLPy2sMYtBfmQxncoZ40Eqi4zGrjoSAknQIMUnPxas=;
        b=QounHF5staDs4DOGbEwduUkHHWFMfw2zYOte27aPBDD7A7DW+z3+Aqq/X//xVDb0nL
         J7kWQD6+1zLIdlnX6Yt5qC8EHzosIgy4eYIKRekNsVfuUlFXakjN/GyTymRLs4JVS7J9
         sMMDCEs4HkUyZ7jEbiUxeoGnxOX8OmSwmauxbZd+lLI/rGVxZDpY/GpqwfxGEQ6PWUIo
         QGfMfrp+0/bH0HbK0tsB5KEcQ7s8D6ZUVgF9W6/hPkOEgqfSLKsBhxHYX3qLSi3rn01j
         R6mqc5d5YMpoLQvgXCCesyiKAVZ0ZF/SlTbwZ4LtzmKzBJ+v1ZlIr/cxJYKTWRgcWWzg
         MDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678354972;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wuLPy2sMYtBfmQxncoZ40Eqi4zGrjoSAknQIMUnPxas=;
        b=fYznxfyw96mtiEv+9gv3V3gejZG7WPfofALSj/0IKVbGFYHViwftXF8q/yrcWeOAKU
         BgXgWhvEvHsEXK8ytS8O7dR/EBCmdfKJPGJifbSMeFVqrNwUM3L0NmnAvQ0ZNrIOwszs
         +PV/iWPkcbvgAe7C2x2iNJHHwPsRgMmkteVWUUihzvNojhqReToUykQDrRVsMP/fZlWn
         2ETPJoO1fe2pg6BVFHTJi8Ij2SXUnezc0YktuEDb3qIngyRteQQk7n/+/CceDHfbYi56
         FeXa2ADi9qnqWfUjd53EiW2FMDaXCZySqMJ4LMkq70HrWoBXKW5rynjcSMIuJza96jbC
         Y3Ew==
X-Gm-Message-State: AO0yUKU7GvlO35sQM+066JtyGVZvIl020S/U9H+EYwR5v7MqWNVMg/q0
        ZErc2qoguwxmegq+z+298ddI23fhkD30OD7tQYRugm7zzgs=
X-Google-Smtp-Source: AK7set+oTy1pFQhd93mb0R6GUkxa6hLKJ8n2ZIs8qWW/GxRdlg5mKauE8TCfF5QOc7UQWDUmaf28ru42xMHqLpoK8DE=
X-Received: by 2002:a5d:6787:0:b0:2cb:c474:75aa with SMTP id
 v7-20020a5d6787000000b002cbc47475aamr4617734wru.10.1678354972559; Thu, 09 Mar
 2023 01:42:52 -0800 (PST)
MIME-Version: 1.0
From:   Sylvain Menu <sylvain.menu@gmail.com>
Date:   Thu, 9 Mar 2023 10:42:41 +0100
Message-ID: <CACH9xG8-tEtWstUVmD9eZFEEAqx-E8Gs14wDL+=uNtBK=-KJvQ@mail.gmail.com>
Subject: nfs mount disappears due to inode revalidate failure
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, chuck.lever@oracle.com,
        jlayton@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I am writing to report an issue on a nfs mount that disappears due to
an inode revalide failure (already sent in January but probably banned
with html format...).
This very old commit
(https://github.com/torvalds/linux/commit/cc89684c9a265828ce061037f1f79f4a68ccd3f7)
exactly show the problem I have and this old resolved issue
(https://bugzilla.kernel.org/show_bug.cgi?id=117651) is probably
failing again today

To sum up, I have a NFS mount inside another NFS mount (for example:
/opt/nfs/mount1 & /opt/nfs/mount1/mount2).
If I kill a task trying to get a file descriptor on
/opt/nfs/mount1/mount2 then it will be unmounted. My simple test code
to reproduce very easily:

int main(int argc, char *argv[]) {
    while (1) {
        close(open(argv[1], O_RDONLY));
    }
}

In logs, I have: "nfs_revalidate_inode: (0:62/845965) getattr failed,
error=-512"

Tested on 5.19 and 6.1 kernel

Best regards,
Sylvain Menu
