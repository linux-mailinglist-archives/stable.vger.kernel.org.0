Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE7859552C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiHPI1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiHPI0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:26:02 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A821405E0
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:58:09 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id c9-20020a05660221c900b00688a5a621afso1009289ioc.9
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=lUHutYvTWkC02k1JHzLmqGKDgiRolEQq5obnJ8zZPao=;
        b=Yli6nkN6S8YFwEo1HsC2MiB8zbkLDMjGCAeZNQ1atFG1EMkK0XNEfh+G/s+nVLdcVt
         lv7oJFfG3CNcXQguvGjLeHQtTjReXVqrnD3xoc61BUUbE+XozuVoBhN3XW69m8CfIs5E
         qDRHnTKtq+w3Shxrcsf1k6sXNej1KTG4373/7ihTUGtGgybOdGjjtAQtNwocZRJeAymy
         +K6f5fJBBAnm0v/MiTzKMCb4Xw5oPsB0gmyI1slIGdT5+wKdwkaSI+ZNGqu6Mfs5mSSF
         e2OpXakTQmS7Bdv/lnmF1PCEIgD7ogsBMzmMDrIG5DD/5eG52e4FgRRNHecg4dicrTso
         gxqw==
X-Gm-Message-State: ACgBeo2FUlqfUFsfNLrL8RSNVrVne91NvY11J3+O3F+v4rF2/27JMmqF
        opJOndEE/qQlWZTC3SjqYcktPqeW7CXrpr16KHWyVeOeYFA3
X-Google-Smtp-Source: AA6agR5xlqIUCDW7/LHVLDMOCEAifJLoInIbGB8XrCdW2sWYNDqAtG4CM3T91W0o7i7Os/k2xLXXOpNa8DlLGy4FJj8FrzXAZVhs
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194d:b0:2de:a54b:2e51 with SMTP id
 x13-20020a056e02194d00b002dea54b2e51mr8736771ilu.257.1660629488569; Mon, 15
 Aug 2022 22:58:08 -0700 (PDT)
Date:   Mon, 15 Aug 2022 22:58:08 -0700
In-Reply-To: <000000000000aaac8505dc135b07@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c518d505e6556ed8@google.com>
Subject: Re: BUG: corrupted list in insert_work
From:   syzbot <syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        brauner@kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net,
        dvyukov@google.com, hannes@cmpxchg.org, hdanton@sina.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lizefan.x@bytedance.com, lkp@intel.com, lkp@lists.01.org,
        mkoutny@suse.com, netdev@vger.kernel.org, oliver.sang@intel.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        syzkaller-android-bugs@googlegroups.com,
        syzkaller-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit d007f49ab789bee8ed76021830b49745d5feaf61
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed May 18 06:13:40 2022 +0000

    percpu_ref_init(): clean ->percpu_count_ref on failure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c66b6b080000
start commit:   ebc9fb07d294 ANDROID: random: fix CRC issues with the merge
git tree:       android12-5.10-lts
kernel config:  https://syzkaller.appspot.com/x/.config?x=32c952ff4a8ff8c1
dashboard link: https://syzkaller.appspot.com/bug?extid=e42ae441c3b10acf9e9d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172a9074080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10456caa080000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: percpu_ref_init(): clean ->percpu_count_ref on failure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
