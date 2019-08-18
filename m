Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C4291798
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 17:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfHRP7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 11:59:44 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35587 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfHRP7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 11:59:44 -0400
Received: by mail-ed1-f68.google.com with SMTP id w20so9116485edd.2
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 08:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=YtQgJT4A494ui6fKTGfhBmRclNb93UrWDKY2hAFB+k0=;
        b=Y6gYv1U3OAAC3iCSlTkDucEcgde+5dSj+cWQU4xVBz20xWr1xp6L9DXeJ9mUQCkHJh
         MpAJVdafaECCC8ZhPuEBUd8titt9NTAIvw2QOkAeNJS7TcwABnE3pDOHpqUC/VIrEaZu
         FDhOMgCljVp/rcNzUYv6QAlvgr4ciMynWuzYErb2+dqZ8H3xB5gqjzmqT8BKlvly76pA
         WcqAvfYnsyKICgrQanWJutLxWDdfpjpwMZ4jL7tcjzsyq57N7YdoX5r9b69dwWd5x30p
         m3XEyM1PUyvydahmvmwweBsXuxaBgdqO4BuKGikfvA0HDD/nE75PPnrvuHLmslLvFZxS
         BY5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=YtQgJT4A494ui6fKTGfhBmRclNb93UrWDKY2hAFB+k0=;
        b=ZDKhP6fjhkmKrmqoR41ecGDXVUacgvgfyz2p3Vwjh9BylD9Cb5TrE9Z85bt2eEW4gp
         CC4yveRukD2MiasUW7Q+VNpFFKmt84fguzeZsnaVmKVadgnkKXpq0W8Z4cUpRqkmwqiI
         mPxm3t4qeXwUlVC5ScYN6Nk8TR6OT6wA9SG7MSkJB6Ev9RPNACd7BjtiKUo4ZZZnRQxT
         Oxy4HIWjIeap/0a1zJ2zMJWAk4VMp2eNLN2WBjK+yqSXvBIq/89igWNfrYvPPdx0LzpO
         BtUQ0MZC+CwPlvichHkcTknrNcCwKi+XDzoLothK80mR7lESPXXZD3ctTC1P7WyjSgvV
         j10w==
X-Gm-Message-State: APjAAAUk6aAf4Xc8WnaB1RjtHepS6VpRoal95BqviJGB4s2DXaOFCpMi
        KP89ANkO2bOgUeCrVgywNSg=
X-Google-Smtp-Source: APXvYqw48WKeGICutTb+RMvs5fZM9ahepU3aXgbUsKlm8lRZy6FUoJj2ptG627uA0qJuXRZrmP8ORg==
X-Received: by 2002:a17:906:c669:: with SMTP id ew9mr17858117ejb.217.1566143982421;
        Sun, 18 Aug 2019 08:59:42 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id m23sm797415ejj.61.2019.08.18.08.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 08:59:41 -0700 (PDT)
Date:   Sun, 18 Aug 2019 17:59:41 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
Cc:     stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Chris Hofstaedtler <zeha@debian.org>
Subject: Backport request for bcb44433bba5 ("dm: disable DISCARD if the
 underlying storage no longer supports it")
Message-ID: <20190818155941.GA26766@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

In Debian bug https://bugs.debian.org/934331 ran into issues which
match the upstream commit bcb44433bba5 ("dm: disable DISCARD if the
underlying storage no longer supports it").

This commit was CC'ed to stable, but only got applied in v5.0.8 (and
later on backported by Ben Hutchings to v3.16.72).

Mike, I have not checked how easily that would be for older stable
versions, but can the backport be considered for versions down to 4.9?
Apparently Ben did succeed with some changes needed. To 4.19 it should
apply with a small conflict in drivers/md/dm-core.h AFAICS.

Regards,
Salvatore
