Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA409586BE
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 18:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF0QNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 12:13:01 -0400
Received: from mail-yb1-f180.google.com ([209.85.219.180]:44922 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0QNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 12:13:00 -0400
Received: by mail-yb1-f180.google.com with SMTP id j15so1834144ybh.11;
        Thu, 27 Jun 2019 09:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=svVGasx9FtsXEe0EJ0V55z0RqDtnu6EmPDKIV7VV/tg=;
        b=iEWeBbTigq5jpeJO4fQylTrqZJdnOVcDW01UBqvJI7E/SdLENcyaDx7xvQbJSG9vsj
         0dHUg0Wvmlz78j5jOIexmVMSUWF+3Dg13SU2GXMSQQ5QKg7JYGiaY4AETS6pj+yO94ss
         HW60QQFlv4pAJsX9JNh/NwRO0xSHNNEr4NgJcgXXA9dRNL3bZsRP5LY+dm4Or6oqHAo3
         Wr2chgQkUe7z84NteF2ROUCCyf5qekOBX7gJs+pJYIhUKvxsHqyRYB0QVU4uY8ksqpPO
         gLNOzTrJIRuU/ke+bG2stdwGM86S5hkmbSmqTLI9CWZyG5FYQar4QSbWXbYaBuTiqgcH
         C/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=svVGasx9FtsXEe0EJ0V55z0RqDtnu6EmPDKIV7VV/tg=;
        b=mIlBOEXgjDlwJZd2wDepyJAjl5wChhS90a9DAHW/vGUais5e/9J6EW6/PKKNR3wuO/
         0XDxgKlDALbM93caPlP9Cz8FjaXah3poKSd4d6cGO/AudWOH3oMOCm0t5uR62u38ObrV
         hMWhqBV8PhWBcNUTr/tsfIEEoQJunmhnwpvksZOGTp8lzNyT7x1kzHYkN8loXZ/+fOxo
         RuCogKmEW2wIAjrBzVLN84zBPXMR6MPCPdFOHn0bv3APLcBKesVijZVoAuDPutgqaMHJ
         nkotS/FoTW40xFgSrYb0mxT0bW6pP1l3n7e0m387SCXeYp6oKDL8iVP6iOU3RDgTAyuw
         0pkQ==
X-Gm-Message-State: APjAAAW6ENzTL121SK1yWyj3ew/rky11wmatouzsJ5HBV8U9GQYdwtvU
        8kUGLq6V9TQA7vJlZNsVeXXKCUr70CrHqo0KqDI=
X-Google-Smtp-Source: APXvYqwiOdsBk1CVbq1MeFVR1MLe3OT53WRx+DygeNzAvFdPM3Z/AUlHuIKG9zv5UiYiy/l/WbkxuhO3OQouO9z0UYY=
X-Received: by 2002:a25:744b:: with SMTP id p72mr3199675ybc.439.1561651979742;
 Thu, 27 Jun 2019 09:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <155009104740.32028.193157199378698979.stgit@magnolia> <20190213205804.GE32253@magnolia>
In-Reply-To: <20190213205804.GE32253@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Jun 2019 19:12:48 +0300
Message-ID: <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
Subject: [STABLE 4.19] fixes for xfs memory and fs corruption
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Darrick,

Can I have your blessing on the choice of these upstream commits
as stable candidates?
I did not observe any xfstests regressions when testing v4.19.55
with these patches applied.

Sasha,

Can you run these patches though your xfstests setup?
They fix nasty bugs.

Make sure to update xfsprogs to very latest, because
generic/530 used to blow up (OOM) my test machine...

>
> The first patch fixes a memory corruption that syzkaller found in the
> attr listent code;

3b50086f0c0d xfs: don't overflow xattr listent buffer

> see "generic: posix acl extended attribute memory
> corruption test" for the relevant regression test.

Fixed generic/529

>
> Patches 2 fixes problems found in XFS's unlinked inode recovery code
> that were unearthed by some new testcases.  We're logging nlink==1 temp
> files on the iunlinked list (and then the vfs sets nlink to 0 without
> telling us) which means that we leak them in recovery if we crash
> immediately after the committing the creation of the temp file.
>
> Patch 3 fixes the problem that ifree during recovery can expand the
> finobt but we need to force the ifree code to reserve blocks for the
> transaction because perag reservations aren't set up yet.

e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list

>
> See "[PATCH v2 2/2] generic: check the behavior of programs opening a
> lot of O_TMPFILE files" for the regression test.
>

Fixes generic/530

Thanks,
Amir.
