Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800EF28DFFE
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 13:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388261AbgJNLtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 07:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388327AbgJNLsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 07:48:53 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9942C0613D2
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 04:48:52 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id f10so3124534otb.6
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=cre2UEL/BbEgrNfOji+1UprEpZv5w7o5nTUd4Wp2jbs=;
        b=EAwBUQsJ/Z/iCHZ7VzbAlXkiveRWNRI9nl6r0vXqADJfan6KUcAqCkdUoJM4ZYbmT4
         mwEqjZVLuzacdP5ULMTiygOXdU1ZvKl2rtDEVswTnBsLPwTNxvAPdbTAny+9tJh4v+KT
         PDxUm4LTTCu7wMUbNJqofsfH2LWcXdPmySz0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cre2UEL/BbEgrNfOji+1UprEpZv5w7o5nTUd4Wp2jbs=;
        b=ICsaJdtCm7eJyYM1QIRzX7RRyILoMKlBvlBJo6xACV3KViilusIJylvO5QSJxqbfUu
         nyANN+PTzFei7DeoHE3u6cegGX4/O4f864ST/pBL/RUXJHGg31Pw4e4ESz2oFBvZ/PA9
         rYIyU8k/VOtX+Q6WNBkpkoPq806vBgoe1ASLV1IahalAInZlzDz6QB09+ynEUS2/EL98
         fNIMk3fTtNINKDFy5Q2ZYkyNOEG/g+6q0SaBbAiAbIy+69Vzuv2yT8Rv717XFblEGoQu
         S9yKMhJq7qNoe9qj2LiT0GdEZFLC3bDbtNI4yFrhg1tz0MmCtNX/KONCJh8FpWO/XMMJ
         qOsg==
X-Gm-Message-State: AOAM532EZLIVIMkr/qe2bD+M/ubL76T75nEXu0jksPiL00ue7EnY2dfe
        LrPPpYlmdVFYBQw6x5lI6RJH/zvAeT4MChhiUIxWTFiIj7+LGA==
X-Google-Smtp-Source: ABdhPJyN/GD5NXhUV3M4Idiq2iDVV5bX7H6vefafHIPJtOe4H5sSUnAHcNWBljGL0bQ5Q460GfpNsKFFNZfPOsYEjOY=
X-Received: by 2002:a05:6830:140b:: with SMTP id v11mr3240859otp.92.1602676132136;
 Wed, 14 Oct 2020 04:48:52 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Barker <pbarker@konsulko.com>
Date:   Wed, 14 Oct 2020 12:48:42 +0100
Message-ID: <CAM9ZRVvsdgad9sSuDGfwCBBZ5cD8zsMsq=TQBzWZyTZkaZGNdQ@mail.gmail.com>
Subject: Backport request: commit 168200b6 to fix perf build with gcc 10
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

I'm seeing errors building perf with gcc 10 on the linux-5.4.y branch.
The linker fails as the traceid_list symbol is defined in multiple
compilation units. It looks like commit
168200b6d6ea0cb5765943ec5da5b8149701f36a ("perf cs-etm: Move
definition of 'traceid_list' global variable from header file") was
added to master to fix this but it's not been backported yet.
Cherry-picking this commit locally fixed my build issues.

Looking at the Fixes tag in that commit, this should probably go into
every stable branch from 4.16.y onwards which is still maintained.

See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=168200b6d6ea0cb5765943ec5da5b8149701f36a

Let me know if you need more info.

Thanks,

-- 
Paul Barker
Konsulko Group
