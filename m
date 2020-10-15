Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA828F46E
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 16:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgJOOIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 10:08:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgJOOIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 10:08:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FE3rIf164025;
        Thu, 15 Oct 2020 14:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=ZDrP08mgbjZ26yc3pJkM9S7bhn6r7oR6wHAtbo57Izo=;
 b=xzNqydizVSrNkEwWjv1+//yjX5NRhH8hks7UT00T3KkPVgmlMeGWkH3x7Ij3/Lj34wyZ
 fCuYLsI0r7ml2QCe5hCabvFhpCuo9ipt5HXjndrbWK3o3g2ZStsej5r431ck88ORnHmz
 RKIsZt23IKCJ+RMj+5C6S40JJBlYAelXBvPFXvyd7UFKPbbEHEKSq+Ry84Nn0MlPjn2V
 xmHMOYxEWfZ7XpYqmWn881dx7BierHwmbsjmwXH2Nnk6Pz+vkCr3zFNcVl9ZGy4VdpUn
 wUsTJqIZ1DnwPVpXhA1CkL3kqxRgUruy5BJ5lREKUWjQRbuSwmWuSc4W429I9/pFnoQj Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 343vaek6nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 14:08:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FE6dhV013675;
        Thu, 15 Oct 2020 14:08:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 343pw0dy24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 14:08:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09FE8feg019867;
        Thu, 15 Oct 2020 14:08:41 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 07:08:41 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] NFS: Fix mode bits and nlink count for v4 referral dirs
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <a998d760a52f5a86343d608e34802c41977442f7.camel@hammerspace.com>
Date:   Thu, 15 Oct 2020 10:08:40 -0400
Cc:     "ashishsangwan2@gmail.com" <ashishsangwan2@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C0A500CC-E132-4E77-822C-60AE13504289@oracle.com>
References: <20201006151456.20875-1-ashishsangwan2@gmail.com>
 <2d1ff3421a88ece2f1b7708cdbc9d34b00ad3e81.camel@hammerspace.com>
 <CAOiN93mh-ssTDuN1fAptECqc5JpUHtK=1V56jY_0MtWEcT=U2Q@mail.gmail.com>
 <622f03cd08acd861a5155a181191e9ce399bbb37.camel@hammerspace.com>
 <D4D63EB4-DA04-4AAA-8A39-91987AF90E9C@oracle.com>
 <a998d760a52f5a86343d608e34802c41977442f7.camel@hammerspace.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 15, 2020, at 9:59 AM, Trond Myklebust <trondmy@hammerspace.com> =
wrote:
>=20
> On Thu, 2020-10-15 at 09:36 -0400, Chuck Lever wrote:
>>> On Oct 15, 2020, at 8:06 AM, Trond Myklebust <
>>> trondmy@hammerspace.com> wrote:
>>>=20
>>> On Thu, 2020-10-15 at 00:39 +0530, Ashish Sangwan wrote:
>>>> On Wed, Oct 14, 2020 at 11:47 PM Trond Myklebust
>>>> <trondmy@hammerspace.com> wrote:
>>>>> On Tue, 2020-10-06 at 08:14 -0700, Ashish Sangwan wrote:
>>>>>> Request for mode bits and nlink count in the
>>>>>> nfs4_get_referral
>>>>>> call
>>>>>> and if server returns them use them instead of hard coded
>>>>>> values.
>>>>>>=20
>>>>>> CC: stable@vger.kernel.org
>>>>>> Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
>>>>>> ---
>>>>>> fs/nfs/nfs4proc.c | 20 +++++++++++++++++---
>>>>>> 1 file changed, 17 insertions(+), 3 deletions(-)
>>>>>>=20
>>>>>> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
>>>>>> index 6e95c85fe395..efec05c5f535 100644
>>>>>> --- a/fs/nfs/nfs4proc.c
>>>>>> +++ b/fs/nfs/nfs4proc.c
>>>>>> @@ -266,7 +266,9 @@ const u32 nfs4_fs_locations_bitmap[3] =3D {
>>>>>>     | FATTR4_WORD0_FSID
>>>>>>     | FATTR4_WORD0_FILEID
>>>>>>     | FATTR4_WORD0_FS_LOCATIONS,
>>>>>> -     FATTR4_WORD1_OWNER
>>>>>> +     FATTR4_WORD1_MODE
>>>>>> +     | FATTR4_WORD1_NUMLINKS
>>>>>> +     | FATTR4_WORD1_OWNER
>>>>>>     | FATTR4_WORD1_OWNER_GROUP
>>>>>>     | FATTR4_WORD1_RAWDEV
>>>>>>     | FATTR4_WORD1_SPACE_USED
>>>>>> @@ -7594,16 +7596,28 @@ nfs4_listxattr_nfs4_user(struct inode
>>>>>> *inode,
>>>>>> char *list, size_t list_len)
>>>>>> */
>>>>>> static void nfs_fixup_referral_attributes(struct nfs_fattr
>>>>>> *fattr)
>>>>>> {
>>>>>> +     bool fix_mode =3D true, fix_nlink =3D true;
>>>>>> +
>>>>>>     if (!(((fattr->valid & NFS_ATTR_FATTR_MOUNTED_ON_FILEID)
>>>>>> ||
>>>>>>            (fattr->valid & NFS_ATTR_FATTR_FILEID)) &&
>>>>>>           (fattr->valid & NFS_ATTR_FATTR_FSID) &&
>>>>>>           (fattr->valid & NFS_ATTR_FATTR_V4_LOCATIONS)))
>>>>>>             return;
>>>>>>=20
>>>>>> +     if (fattr->valid & NFS_ATTR_FATTR_MODE)
>>>>>> +             fix_mode =3D false;
>>>>>> +     if (fattr->valid & NFS_ATTR_FATTR_NLINK)
>>>>>> +             fix_nlink =3D false;
>>>>>>     fattr->valid |=3D NFS_ATTR_FATTR_TYPE |
>>>>>> NFS_ATTR_FATTR_MODE |
>>>>>>             NFS_ATTR_FATTR_NLINK |
>>>>>> NFS_ATTR_FATTR_V4_REFERRAL;
>>>>>> -     fattr->mode =3D S_IFDIR | S_IRUGO | S_IXUGO;
>>>>>> -     fattr->nlink =3D 2;
>>>>>> +
>>>>>> +     if (fix_mode)
>>>>>> +             fattr->mode =3D S_IFDIR | S_IRUGO | S_IXUGO;
>>>>>> +     else
>>>>>> +             fattr->mode |=3D S_IFDIR;
>>>>>> +
>>>>>> +     if (fix_nlink)
>>>>>> +             fattr->nlink =3D 2;
>>>>>> }
>>>>>>=20
>>>>>> static int _nfs4_proc_fs_locations(struct rpc_clnt *client,
>>>>>> struct
>>>>>> inode *dir,
>>>>>=20
>>>>> NACK to this patch. The whole point is that if the server has a
>>>>> referral, then it is not going to give us any attributes other
>>>>> than
>>>>> the
>>>>> ones we're already asking for because it may not even have a
>>>>> real
>>>>> directory. The client is required to fake up an inode, hence
>>>>> the
>>>>> existing code.
>>>>=20
>>>> Hi Trond, thanks for reviewing the patch!
>>>> Sorry but I didn't understand the reason to NACK it. Could you
>>>> please
>>>> elaborate your concern?
>>>> These are the current attributes we request from the server on a
>>>> referral:
>>>> FATTR4_WORD0_CHANGE
>>>>> FATTR4_WORD0_SIZE
>>>>> FATTR4_WORD0_FSID
>>>>> FATTR4_WORD0_FILEID
>>>>> FATTR4_WORD0_FS_LOCATIONS,
>>>> FATTR4_WORD1_OWNER
>>>>> FATTR4_WORD1_OWNER_GROUP
>>>>> FATTR4_WORD1_RAWDEV
>>>>> FATTR4_WORD1_SPACE_USED
>>>>> FATTR4_WORD1_TIME_ACCESS
>>>>> FATTR4_WORD1_TIME_METADATA
>>>>> FATTR4_WORD1_TIME_MODIFY
>>>>> FATTR4_WORD1_MOUNTED_ON_FILEID,
>>>>=20
>>>> So you are suggesting that it's ok to ask for SIZE, OWNER, OWNER
>>>> GROUP, SPACE USED, TIMESTAMPs etc but not ok to ask for mode bits
>>>> and
>>>> numlinks?
>>>=20
>>> No. We shouldn't be asking for any of that information for a
>>> referral
>>> because the server isn't supposed to return any values for it.
>>>=20
>>> Chuck and Anna, what's the deal with commit c05cefcc7241? That
>>> appears
>>> to have changed the original code to speculatively assume that the
>>> server will violate RFC5661 Section 11.3.1 and/or RFC7530 Section
>>> 8.3.1.
>>=20
>> The commit is an attempt to address the many complaints we've had
>> about the ugly appearance of referral anchors. The strange "special"
>> default values made the client appear to be broken, and was confusing
>> to some. I consider this to be a UX issue: the information displayed
>> in this case is not meant to be factual, but rather to prevent the
>> user concluding that something is wrong.
>>=20
>> I'm not attached to this particular solution, though. Does it make
>> sense to perform the referral mount before returning "ls" results
>> so that the target server has a chance to supply reasonable
>> attribute values for the mounted-on directory object? Just spit
>> balling here.
>>=20
>>=20
>>> Specifically, the paragraph that says:
>>>=20
>>> "
>>>  Other attributes SHOULD NOT be made available for absent file
>>>  systems, even when it is possible to provide them.  The server
>>> should
>>>  not assume that more information is always better and should
>>> avoid
>>>  gratuitously providing additional information."
>>>=20
>>> So why is the client asking for them?
>>=20
>> This paragraph (and it's most modern incarnation in RFC 8881 Section
>> 11.4.1) describes server behavior. The current client behavior is
>> spec-compliant because there is no explicit prohibition in the spec
>> language against a client requesting additional attributes in this
>> case.
>>=20
>> Either the server can clear those bitmap flags on the GETATTR reply
>> and not supply those attributes, and clients must be prepared for
>> that.
>>=20
>> Or, it's also possible to read this paragraph to mean that the
>> server can provide those attributes and the values should not
>> reflect attributes for the absent file system, but rather something
>> else (eg, server-manufactured defaults, or the attributes from the
>> object on the source server).
>>=20
>> And since this is a SHOULD NOT rather than a MUST NOT, servers are
>> still free to return information about the absent file system.
>> Clients are not guaranteed this will be the case, however.
>>=20
>> I don't think c05cefcc7241 makes any assumption about whether the
>> server is lying about the extra attributes. Perhaps the server has
>> no better values for these attributes than the client's defaults
>> were.
>>=20
>=20
> SHOULD / SHOULD NOT indicates actions that the server is required to
> take in the absence of a very good reason to do otherwise. In other
> words, the client should expect the majority of servers to behave in a
> certain manner.
>=20
> It doesn't matter that the client's behaviour is spec compliant. We're
> asking for information that is not supposed to be divulged by the
> majority of servers, Furthermore, that information is, quite frankly,
> utterly irrelevant to the client and application running on it. Any
> attempt to access that fake object will result in a submount of
> something completely different on top of that object.
>=20
> IOW: the only difference here is you're asking that the server provide
> us with a faked up object (which it is not supposed to do), whereas
> previously, we were faking that object up ourselves. What's the big
> deal here?

Right, that boils it down nicely.

The difference has been that by and large the server-provided values
don't look broken to users. Perhaps all we need to do is select better
defaults for these attributes on Linux clients. I haven't followed
Ashish's requirements, so I can't speak to them.

Here is some history.

=
https://lore.kernel.org/linux-nfs/CAD8zhTAAvTKhp6k0vYRMnhZW5pxjstpBiDKLgoX=
ocfpAXNjKTg@mail.gmail.com/


--
Chuck Lever



